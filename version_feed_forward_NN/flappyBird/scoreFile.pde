void topScoreFileLoader(){
  String lines[] = loadStrings("data.aff");
  TopScore=unhex(lines[2]);
}
void topScoreFileUpdator(){
  String words = "5df5745h5 @#SDG54541sfs "+hex(TopScore)+" YUGYU56%^$%tgrtYTFG% HJHDS45%$%$ 8674543423&&^(DSHFJU 7451#Dd";
  String[] list = split(words, ' ');

  // Writes the strings to a file, each on a separate line
  saveStrings("data.aff", list);
}
