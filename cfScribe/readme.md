#CFScribe

Please visit the full documents at [https://cfscribe.ortusbooks.com/](https://cfscribe.ortusbooks.com/)




### ChangeLog
0.0.9 - Cumulative fixes including null issue on Sentry Appender, handling init in Pusher, default values in Scribe Interceptor,
        changed default behavior for development logging to scribeConsole instead of sreenDump, passing tests in ACF 2021
        

0.0.8 - scribeConsole to accommodate Arrays

0.0.7 - updated to use ErrorFilter 0.0.9, added argumentCollection to log, logMessage, fatal, error, warn, info and debug calls. Also included the "argument:name" ruleDefinition parser. Removed old tests.  

0.0.6 - Fixed bug in scribeConsole which automatically filtered out blank lines whether that setting was true or false. 
        Removed unnecessary settings from moduleConfig
        changed the rule definition for the severity from "severity:severity" to simply "severity"
