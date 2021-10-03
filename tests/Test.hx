package;

import webidl.Types.VoidPtr;
import derplanner.Native;

class Test {

    static  var objects : Array<String> = [ "SPB", "LED", "MSC", "SVO" ];


static function print_tuple( name : String,  values : VoidPtr,  layout : ParamLayout)
{
    var line = name + "(";

    for ( i in 0...layout.numParams) {
//        trace("" + i);
        var value = derplanner.Native.Tuple.asID(values, layout, i);
  //      trace("Value" + value);
//        var value = plnnr::as_Id32(values, layout, i);
        line = line + objects[value];

        if (i + 1 != layout.numParams)
        {
            line = line + ", ";
        }
    }

    trace(line + ")");
}

static function print_plan(state : PlanningState, domain : DomainInfo)
{
    var plan = state.getPlan();
    for (i in 0...plan.length)
    {
        var task = plan.getTaskFrame(i);
        var name = domain.getTaskName( task.task_type);
        var layout = domain.getTaskParamLayout( task.task_type);

//        trace("Printing tupple");
        print_tuple(name, task.arguments, layout);
    }
}



    public static function main() {
        trace("Starting test");
        derplanner.Native.TravelDomain.init();
        var td = derplanner.Native.TravelDomain.get();

        var default_mem = new derplanner.Native.MemoryDefault();
        var db = new derplanner.Native.FactDatabase();

        var fmt = td.getFormat();

        // create database using format provided in domain info.
        db.init( default_mem, fmt);

        trace("Finding table");
        var start = db.findTable("start");
        var  finish           = db.findTable( "finish");
        var  short_distance   = db.findTable( "short_distance");
        var  long_distance    = db.findTable( "long_distance");
        var  airport          = db.findTable( "airport");
    
        trace("Setting entry");
        //city
        final SPB = 0;
        //sirport
        final LED = 1;  
        //city
        final MSC = 2;
        //airport
        final SVO = 3;

        start.addEntry(SPB);
        finish.addEntry( MSC);

        short_distance.addEntry( SPB, LED);
        short_distance.addEntry( LED, SPB);
        short_distance.addEntry( MSC, SVO);
        short_distance.addEntry( SVO, MSC);
    
        long_distance.addEntry( SPB, MSC);
        long_distance.addEntry( MSC, SPB);
        long_distance.addEntry( LED, SVO);
        long_distance.addEntry( SVO, LED);
        long_distance.addEntry( SPB, SVO);
        long_distance.addEntry( SVO, SPB);
        long_distance.addEntry( MSC, LED);
        long_distance.addEntry( LED, MSC);
    
        airport.addEntry( SPB, LED);
        airport.addEntry( MSC, SVO);
        trace("Configuring planner");

        // create planning state.
        var config = new derplanner.Native.PlanningStateConfig();
        config.max_depth = 5;
        config.max_plan_length = 3;
        config.expansion_data_size = 1024;
        config.plan_data_size = 1024;
        config.max_bound_tables = fmt.numTables;

        trace("Creating planner");

        var ps = new derplanner.Native.PlanningState();
        ps.init(default_mem, config);

        trace("binding planner");

        ps.bind( td, db );
        
        trace("Finding plan");

        var status = ps.findPlan(db, td );
        if (status == FindPlanStatus.Find_Plan_Max_Depth_Exceeded)
        {
            trace("maximum expansion depth exceeded!");
        }
        else if (status == FindPlanStatus.Find_Plan_Max_Plan_Length_Exceeded)
        {
            trace("maximum plan length exceeded!");
        } else if (status == FindPlanStatus.Find_Plan_Failed) {
            trace("Plan failed");
        } else {
            trace("Plan succeeded");
        }
    
        

        // resulting plan is stored on the task stack.
        trace("plan:");

        print_plan(ps, td);


        trace("Ending test");
    }
}