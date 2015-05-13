module stringex.unidecode;
import yaml;
import std.utf;
import std.format;
import std.path;

class UniDecoder {
	Node[string] yamls;

	this() {
	}

	string decode(string input) {
		string result = "";

		foreach(c; input.byDchar()) {
			auto code_group = format("x%02x", c >> 8);
			auto grouped_point = c & 255;
			auto decoded = getReplacement(code_group, grouped_point);
			result ~= decoded;
		}

		return result;
	}

	void loadYml(string name) {
		Node yaml = Loader(buildPath("source", "yamls", name~".yml")).load();
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

string uni_decode(string input) {
	auto decoder = new UniDecoder();
	return decoder.decode(input);
}