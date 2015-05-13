import std.stdio;
import stringex.unidecode;

void main()
{
	auto string1 = "ąa ę śvć Ā";
	auto string2 = "さらにブリーダーズカップ・クラシックを勝つなどG1を5勝する活躍を見せ";
	
	auto decoder = new UniDecoder();
	writeln(string2);
	writeln(decoder.decode(string2));

	writeln(string1);
	writeln(string1.unidecode());
}
