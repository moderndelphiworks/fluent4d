program PTestFluentCQL;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  FastMM4,
  DUnitX.MemoryLeakMonitor.FastMM4,
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  UTestFluent4D.CQL in 'UTestFluent4D.CQL.pas',
  System.Fluent.Adapters in '..\Source\System.Fluent.Adapters.pas',
  System.Fluent.Collections in '..\Source\System.Fluent.Collections.pas',
  System.Fluent.Core in '..\Source\System.Fluent.Core.pas',
  System.Fluent in '..\Source\System.Fluent.pas',
  System.Fluent.Query.Provider in '..\Source\System.Fluent.Query.Provider.pas',
  System.Fluent.SkipWhile in '..\Source\System.Fluent.SkipWhile.pas',
  System.Fluent.Where in '..\Source\System.Fluent.Where.pas',
  System.Fluent.Select in '..\Source\System.Fluent.Select.pas',
  System.Fluent.Take in '..\Source\System.Fluent.Take.pas',
  System.Fluent.Skip in '..\Source\System.Fluent.Skip.pas',
  System.Fluent.OrderBy in '..\Source\System.Fluent.OrderBy.pas',
  System.Fluent.Distinct in '..\Source\System.Fluent.Distinct.pas',
  System.Fluent.GroupBy in '..\Source\System.Fluent.GroupBy.pas',
  System.Fluent.TakeWhile in '..\Source\System.Fluent.TakeWhile.pas',
  System.Fluent.Zip in '..\Source\System.Fluent.Zip.pas',
  System.Fluent.Join in '..\Source\System.Fluent.Join.pas',
  System.Fluent.OfType in '..\Source\System.Fluent.OfType.pas',
  System.Fluent.SelectMany in '..\Source\System.Fluent.SelectMany.pas',
  System.Fluent.GroupJoin in '..\Source\System.Fluent.GroupJoin.pas',
  System.Fluent.Exclude in '..\Source\System.Fluent.Exclude.pas',
  System.Fluent.Intersect in '..\Source\System.Fluent.Intersect.pas',
  System.Fluent.Union in '..\Source\System.Fluent.Union.pas',
  System.Fluent.Concat in '..\Source\System.Fluent.Concat.pas',
  System.Fluent.Order in '..\Source\System.Fluent.Order.pas',
  System.Fluent.SelectIndexed in '..\Source\System.Fluent.SelectIndexed.pas',
  System.Fluent.SelectManyIndexed in '..\Source\System.Fluent.SelectManyIndexed.pas',
  System.Fluent.SelectManyCollection in '..\Source\System.Fluent.SelectManyCollection.pas',
  System.Fluent.SelectManyCollectionIndexed in '..\Source\System.Fluent.SelectManyCollectionIndexed.pas',
  System.Fluent.SkipWhileIndexed in '..\Source\System.Fluent.SkipWhileIndexed.pas',
  System.Fluent.TakeWhileIndexed in '..\Source\System.Fluent.TakeWhileIndexed.pas',
  System.Fluent.Chunk in '..\Source\System.Fluent.Chunk.pas',
  System.Fluent.ThenBy in '..\Source\System.Fluent.ThenBy.pas',
  System.Fluent.Cast in '..\Source\System.Fluent.Cast.pas',
  System.Fluent.Queryable in '..\Source\System.Fluent.Queryable.pas',
  System.Fluent.Xml in '..\Source\System.Fluent.Xml.pas',
  System.Fluent.Json in '..\Source\System.Fluent.Json.pas',
  System.Fluent.Xml.Provider in '..\Source\System.Fluent.Xml.Provider.pas',
  System.Fluent.Json.Provider in '..\Source\System.Fluent.Json.Provider.pas',
  System.Fluent.Helpers in '..\Source\System.Fluent.Helpers.pas',
  System.Fluent.Parse in '..\Source\System.Fluent.Parse.pas',
  System.Fluent.Expression in '..\Source\System.Fluent.Expression.pas',
  System.Evolution.Tuple in '..\..\Evolution4D\Source\System.Evolution.Tuple.pas';

{ keep comment here to protect the following conditional from being removed by the IDE when adding a unit }
{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    TDUnitX.Options.ExitBehavior := TDUnitXExitBehavior.Pause;
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
