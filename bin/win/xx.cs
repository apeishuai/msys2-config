public class MyScript
{
     [Start]
     public void MyFunction()
     {
           new Decider().Decide(EnumDecisionType.eOkDecision, "Hello World!", "My Script", EnumDecisionReturn.eOK, EnumDecisionReturn.eOK);
           return;
     }
}