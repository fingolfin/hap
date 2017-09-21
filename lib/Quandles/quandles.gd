##
##
##			Cédric FRAGNAUD - 2017
##
##
##

########################################## QUANDLES ##########################################

DeclareCategory("IsHapConjQuandElt",IsMultiplicativeElement);
DeclareRepresentation(  "IsHapConjQuandEltRep", IsComponentObjectRep, IsMultiplicativeElementWithInverse);
HapConjQuandEltFamily:=NewFamily( "HapConjQuandEltFamily", IsHapConjQuandElt, IsHapConjQuandElt);
HapConjQuandElt:=NewType(HapConjQuandEltFamily, IsHapConjQuandEltRep);

DeclareCategory("IsHapQuandlePresentation",IsRecord);
DeclareRepresentation(  "IsHapQuandlePresentationRep", IsComponentObjectRep, IsRecord);
HapQuandlePresentationFamily:=NewFamily( "HapQuandlePresentationFamily",IsHapQuandlePresentation,IsHapQuandlePresentation);
HapQuandlePresentation:=NewType(HapQuandlePresentationFamily,IsHapQuandlePresentationRep);


########

DeclareGlobalFunction("CosetsQuandle");
DeclareGlobalFunction("Cedric_ConjugateQuandleElement");
DeclareGlobalFunction("ConjugationQuandle");
DeclareGlobalFunction("FirstQuandleAxiomIsSatisfied");
DeclareGlobalFunction("SecondQuandleAxiomIsSatisfied");
DeclareGlobalFunction("ThirdQuandleAxiomIsSatisfied");
DeclareGlobalFunction("IsQuandle");
DeclareGlobalFunction("Cedric_CheckThirdAxiomRow");
DeclareGlobalFunction("Cedric_Permute");
DeclareGlobalFunction("Cedric_Quandle1");
DeclareGlobalFunction("Cedric_Quandle2");
DeclareGlobalFunction("Cedric_Quandle3");
DeclareGlobalFunction("Cedric_Quandle4");
DeclareGlobalFunction("Cedric_Quandle5");
DeclareGlobalFunction("Cedric_Quandle6");
DeclareOperation("Quandles",[IsInt]);
DeclareOperation("Quandle",[IsInt,IsInt]);
DeclareGlobalFunction("IdQuandle");
DeclareAttribute("IsLatinQuandle",IsMagma);
DeclareAttribute("IsConnected",IsMagma);
DeclareOperation("ConnectedQuandles",[IsInt]);
DeclareOperation("ConnectedQuandle",[IsInt,IsInt]);
DeclareGlobalFunction("IdConnectedQuandle");
DeclareGlobalFunction("IsQuandleEnvelope");
DeclareGlobalFunction("QuandleQuandleEnvelope");
DeclareAttribute("RightMultiplicationGroupOfQuandleAsPerm",IsMagma);
DeclareAttribute("RightMultiplicationGroupOfQuandle",IsMagma);
DeclareGlobalFunction("Cedric_FromAutGeReToAutQe");
DeclareAttribute("AutomorphismGroupQuandleAsPerm",IsMagma);
DeclareAttribute("AutomorphismGroupQuandle",IsMagma);

DeclareGlobalFunction("TupleOrbitReps_perm");
DeclareGlobalFunction("TupleOrbitReps");
DeclareGlobalFunction("NumberOfHomomorphisms_connected");
DeclareOperation("HomomorphismsImages",[IsHapQuandlePresentation,IsMagma]);
#DeclareGlobalFunction("FundamentalGroupFromQuandle");
DeclareGlobalFunction("AdjointGroupOfQuandle");
DeclareGlobalFunction("DerivedGroupOfQuandle");
DeclareGlobalFunction("QuandleIsomorphismRepresentatives");


########################################## KNOTS ##########################################

DeclareGlobalFunction("PresentationKnotQuandle");
DeclareGlobalFunction("SimplifiedQuandlePresentation");
DeclareGlobalFunction("PD2GC");
DeclareGlobalFunction("PlanarDiagramKnot");
DeclareGlobalFunction("GaussCodeKnot");
DeclareGlobalFunction("PresentationKnotQuandleKnot");
DeclareGlobalFunction("Cedric_IsHomomorphism");
DeclareOperation("NumberOfHomomorphisms",[IsRecord,IsMagma]);
DeclareOperation("PartitionedNumberOfHomomorphisms",[IsRecord,IsMagma]);
DeclareGlobalFunction("KnotInvariantCedric");
