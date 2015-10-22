module stringex.unidecode;
import yaml;
import std.utf;
import std.format;
import std.path;
import std.array;

class UniDecoder {
	Node[string] yamls;

	this() {
	}

	string decode(string input) {
		string result = "";

		foreach(c; input.byDchar()) {
			auto writer = appender!string();
			formattedWrite(writer, "x%02x", c >> 8);
			auto code_group = writer.data;

			auto grouped_point = c & 255;
			auto decoded = getReplacement(code_group, grouped_point);
			result ~= decoded;
		}

		return result;
	}

	void loadYml(string name) {
		Node yaml = Loader(buildPath("unidecode-yaml", name~".yml")).load();
		yamls[name] = yaml;
	}

	string getReplacement(string code_group, int grouped_point) {
		auto ptr = (code_group in yamls);

		if(ptr is null) {
			loadYml(code_group);
		}

		auto replacement_array = yamls[code_group];
		return replacement_array[grouped_point].as!string;
	}
}

string unidecode(string input) {
	auto decoder = new UniDecoder();
	return decoder.decode(input);
}

unittest {
	auto decoder = new UniDecoder();

	assert(decoder.decode("abcd") == "abcd");
	assert(decoder.decode("ABcd") == "ABcd");
	assert(decoder.decode("ABcd ff") == "ABcd ff");
	assert(decoder.decode("żółw") == "zolw");
	assert(decoder.decode("反清復明") == "Fan Qing Fu Ming ");
}
