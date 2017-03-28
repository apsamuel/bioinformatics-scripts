Options[MakeDNA] = {Background -> White, ColorFunction -> "Residue", 
   "HelixType" -> "A", ImageSize -> Automatic, "Hydrogens" -> False, 
   "Rendering" -> "Structure", "SingleStranded" -> False, 
   ViewPoint -> Automatic};

MakeDNA[seq_String, opts : OptionsPattern[]] := 
 Module[{params}, 
  params = {"distro" -> "make-na", "seq_name" -> "0", 
    "helix_type" -> OptionValue["HelixType"], "f_acid_type" -> "dna", 
    "r_acid_type" -> "dna", "description" -> seq, 
    "file_type" -> "pdb", "f_cid" -> "A", "r_cid" -> "B", 
    "f_first_num" -> 1, "r_first_num" -> 1, 
    "sugar_indi" -> "asterisk", 
    "hydrogens" -> If[TrueQ[OptionValue["Hydrogens"]], "yes", "no"], 
    "f_codelen" -> 1, "r_codelen" -> 1};
  If[TrueQ[OptionValue["SingleStranded"]], 
   AppendTo[params, "single_strand" -> "SS"]];
  ImportString[
   URLExecute["http://structure.usc.edu/cgi-bin/make-na/make-na.cgi", 
    params, "String", Method -> "POST"], "PDB", 
   FilterRules[
    Join[{opts}, Options[MakeDNA]], {Background, ColorFunction, 
     ImageSize, "Rendering", ViewPoint}]]]