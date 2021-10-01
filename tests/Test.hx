package;

import derplanner.Native;

class Test {

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

        final SPB = 0;
        start.addEntry(SPB);
        
        // create planning state.
        var config = new derplanner.Native.PlanningStateConfig();
        config.max_depth = 5;
        config.max_plan_length = 3;
        config.expansion_data_size = 1024;
        config.plan_data_size = 1024;
        config.max_bound_tables = fmt.numTables;

        

        trace("Ending test");
    }
}