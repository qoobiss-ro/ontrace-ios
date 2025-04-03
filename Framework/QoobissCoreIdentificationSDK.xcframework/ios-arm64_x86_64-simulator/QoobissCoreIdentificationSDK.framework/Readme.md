

1. Code Cleanup https://github.com/peripheryapp/periphery
   Command periphery scan --setup --retain-public --retain-assign-only-properties
2. Unify Camera for both id and face scan

How to publish a new version of the library

1. Using the script in QoobissCoreIdentificationSDK generate the xcframework
    /Users/vladbuhaescu/Documents/Developement/qoobiss-sdk/QoobissCoreIdentificationSDK/QoobissCoreIdentificationSDK/framework_script.sh
2. Add it to the Qoobiss_iOS_SDK at path /Users/vladbuhaescu/Documents/Developement/qoobiss-sdk/Qoobiss_iOS_SDK/Framework
3. Add a tag to the repo and update the podspec
4. Validate the podspec with "pod lib lint --no-clean --verbose --allow-warnings"
5. pod trunk push OntraceSDK.podspec --allow-warnings
6. validate podspec in the flutter plugin "pod lib lint ontrace_flutter_plugin.podspec --allow-warnings --no-clean" 
    at path   /Users/vladbuhaescu/Documents/Developement/ontrace_flutter_plugin/FlutterPlugin/ontrace_flutter_plugin
    [when running it check the ontrace pod version used in the logs]
