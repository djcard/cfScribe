#CFScribe

Please visit the full documents at [https://cfscribe.ortusbooks.com/](https://cfscribe.ortusbooks.com/)




### ChangeLog
0.0.18 Better Handling of long SQL statements. Added a max width of 80 characters.

0.0.17 Template error fixed

0.0.16 Fixed issue with Pusher environment

0.0.15 Incorrect Pusher key fixed

0.0.14 Updated Pusher appender with more correct settings and values

0.0.13 misc errors

0.0.12 Removed threading from pusher appender because of naming conflicts when used as a singleton. Added examining the ExtraInfo message for text length when calculating output width in scribeConsole

0.0.11 - Fixed issue in scribeConsole where environment was not being populated properly

0.0.10 - fixed error where overloaded arguments from debug(), info(), warn(), error() and fatal() were not being passed all the way through to the rule engine.

0.0.9 - Cumulative fixes including null issue on Sentry Appender, handling init in Pusher, default values in Scribe Interceptor,
        changed default behavior for development logging to scribeConsole instead of sreenDump, passing tests in ACF 2021

0.0.8 - scribeConsole to accommodate Arrays

0.0.7 - updated to use ErrorFilter 0.0.9, added argumentCollection to log, logMessage, fatal, error, warn, info and debug calls. Also included the "argument:name" ruleDefinition parser. Removed old tests.  

0.0.6 - Fixed bug in scribeConsole which automatically filtered out blank lines whether that setting was true or false. 
        Removed unnecessary settings from moduleConfig
        changed the rule definition for the severity from "severity:severity" to simply "severity"
