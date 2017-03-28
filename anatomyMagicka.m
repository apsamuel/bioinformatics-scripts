
AnatomyDataFunctionality[x_] := 
 AnatomyData[Entity["AnatomicalStructure", x], "Function"]


AnatomyDataGraphic[x_] :=
  AnatomyData[Entity["AnatomicalStructure", x], "Graphics3D"]


AnatomyMakeToolTip[x_] :=
  AnatomyData[Entity["AnatomicalStructure", x], "Graphics3D"] /. Annotation[x_, y_] :> Tooltip[x, y["Name"]]