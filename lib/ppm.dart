import 'dart:io';
import 'dart:convert';

const inFileName = 'options.json';
const outFileName = 'pitmap.svg';
const int columnCount = 6;
const int tableRadiusPx = 34;

main() async {
  final teamNums = await readOptionsFile();
  print('team nums $teamNums');
  writeOutputFile(teamNums);
}

Future<List<int>> readOptionsFile() async {
  final jsonStr = await File(inFileName).readAsString();
  final opts = json.decode(jsonStr);
  return List<int>.from(opts['teamNumbers'] as Iterable<dynamic>);

}

void writeOutputFile(List<int> teamNums) {
  final outputFile = File(outFileName);
  final sink = outputFile.openWrite();

  print('ppm writing file "$outFileName"');

  sink.write(createSvgHeader());
  sink.write(createDefs());
  sink.write(createTitleText());
  sink.write(createNorthArrow());

  teamNums.sort();
  for(int i = 0; i < teamNums.length; ++i) {
    final col = i % columnCount;
    final row = i ~/ columnCount;
    print('writing table at $col,$row');

    sink.write(createTable(teamNums[i], row, col));
  }

  sink.write(createSvgFooter());

  sink.close();
}

String createTable(int teamNum, int row, int col) {
  final x = (col + 1) * 92;
  final y = (row + 1) * 100 + 50;

  return '''
    <circle cx="$x" cy="$y" r="$tableRadiusPx" stroke-width="1" stroke="black" fill="white"></circle>
    <circle cx="$x" cy="$y" r="$tableRadiusPx" filter="url(#shadow)" fill="black" ></circle>
    <text x="$x" y="$y" text-anchor="middle" dominant-baseline="middle" font-family="Roboto-Bold, Roboto" font-size="18" font-weight="bold" fill="#1E487C">
      $teamNum
    </text>

  ''';
}

String createSvgHeader() => '''
<?xml version="1.0" encoding="UTF-8"?>
<svg width="8.5in" height="11in" viewBox="0 0 772 1000" version="1.1" 
  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
''';

String createDefs() => '''
  <defs>
      <filter x="-11.0%" y="-8.1%" width="122.1%" height="122.1%" filterUnits="objectBoundingBox" id="shadow">
          <feMorphology radius="0.5" operator="dilate" in="SourceAlpha" result="shadowSpreadOuter1"></feMorphology>
          <feOffset dx="0" dy="2" in="shadowSpreadOuter1" result="shadowOffsetOuter1"></feOffset>
          <feGaussianBlur stdDeviation="2" in="shadowOffsetOuter1" result="shadowBlurOuter1"></feGaussianBlur>
          <feComposite in="shadowBlurOuter1" in2="SourceAlpha" operator="out" result="shadowBlurOuter1"></feComposite>
          <feColorMatrix values="0 0 0 0 0   0 0 0 0 0   0 0 0 0 0  0 0 0 0.5 0" type="matrix" in="shadowBlurOuter1"></feColorMatrix>
      </filter>
  </defs>
''';

String createTitleText() => '''
  <text id="Pit-Area" font-family="Roboto-Bold, Roboto" font-size="60" font-weight="bold" fill="#1E487C">
      <tspan x="189.438477" y="60">Pit Area</tspan>
  </text>
''';

String createNorthArrow() => '''
  <g id="Group" transform="translate(518.000000, 17.000000)">
      <text id="N" font-family="Roboto-Bold, Roboto" font-size="36" font-weight="bold" fill="#1E487C">
          <tspan x="0.291015625" y="70">N</tspan>
      </text>
      <path id="Line" d="M34.1857567,-0.26731789 C34.6866848,-1.2691741 35.9049322,-1.67525657 36.9067884,-1.17432846 
        C37.2992886,-0.97807839 37.6175489,-0.659818032 37.813799,-0.26731789 L37.813799,-0.26731789 
        L52.7854396,29.6759632 C53.2863677,30.6778195 52.8802852,31.8960669 51.878429,32.396995 
        C51.5968111,32.5378039 51.2862768,32.6111111 50.9714184,32.6111111 L50.9714184,32.6111111 L39,32.611 
        L39,70 C39,71.5976809 37.75108,72.9036609 36.1762728,72.9949073 L36,73 C34.3431458,73 33,71.6568542 
        33,70 L33,70 L33,32.611 L21.0281373,32.6111111 C19.9589421,32.6111111 19.0829862,31.783755 19.0055629,30.7343361 
        L19,30.5829738 C19,30.2681155 19.0733072,29.9575811 19.2141162,29.6759632 L19.2141162,29.6759632 Z" 
        fill="#020000" fill-rule="nonzero">
      </path>
  </g>
''';

String createSvgFooter() =>'</svg>\n';