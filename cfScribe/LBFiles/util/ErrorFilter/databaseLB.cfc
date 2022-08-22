component extends="coldbox.system.logging.util.ErrorFilter.ErrorFilterLB" accessors="true" {

	struct function doClean( err ){
		return super.doClean( err, "database" );
	}

}
