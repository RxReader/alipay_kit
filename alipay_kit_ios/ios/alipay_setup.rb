#
# 参考文献
# https://github.com/firebase/flutterfire/blob/master/packages/firebase_crashlytics/firebase_crashlytics/ios/crashlytics_add_upload_symbols
# https://github.com/MagicalWater/Base-APP-Env/blob/master/fastlane/actions/xcode_parse.rb
#

require 'xcodeproj'
require 'plist'
require 'optparse'
require 'uri'

# Dictionary to hold command line arguments
options_dict = {}

# Parse command line arguments into options_dict
OptionParser.new do |options|
    options.banner = "Setup the Alipay to an Xcode target."

    options.on("-p", "--projectDirectory=DIRECTORY", String, "Directory of the Xcode project") do |dir|
        options_dict[:project_dir] = dir
    end

    options.on("-n", "--projectName=NAME", String, "Name of the Xcode project (ex: Runner.xcodeproj)") do |name|
        options_dict[:project_name] = name
    end

    options.on("-a", "--scheme=SCHEME", String, "Scheme for Alipay") do |opts|
        options_dict[:scheme] = opts
    end
end.parse!

# Minimum required arguments are a project directory and project name
unless (options_dict[:project_dir] and options_dict[:project_name])
    abort("Must provide a project directory and project name.\n")
end

# Path to the Xcode project to modify
project_path = File.join(options_dict[:project_dir], options_dict[:project_name])

unless (File.exist?(project_path))
   abort("Project at #{project_path} does not exist. Please check paths manually.\n");
end

# Actually open and modify the project
project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|
    if target.name == "Runner"
        scheme = options_dict[:scheme]

        sectionObject = {}
        project.objects.each do |object|
            if object.uuid == target.uuid
                sectionObject = object
                break
            end
        end
        sectionObject.build_configurations.each do |config|
            infoplist = config.build_settings["INFOPLIST_FILE"]
            if !infoplist
                abort("INFOPLIST_FILE is not exist\n")
            end
            infoplistFile = File.join(options_dict[:project_dir], infoplist)
            if !File.exist?(infoplistFile)
                abort("#{infoplist} is not exist\n")
            end
            result = Plist.parse_xml(infoplistFile, marshal: false)
            if !result
                result = {}
            end
            urlTypes = result["CFBundleURLTypes"]
            if !urlTypes
                urlTypes = []
                result["CFBundleURLTypes"] = urlTypes
            end
            isUrlTypeExist = urlTypes.any? { |urlType| urlType["CFBundleURLSchemes"] && (urlType["CFBundleURLSchemes"].include? scheme) }
            if !isUrlTypeExist
                urlTypes << {
                    "CFBundleTypeRole": "Editor",
                    "CFBundleURLName": "alipay",
                    "CFBundleURLSchemes": [ scheme ]
                }
                File.write(infoplistFile, Plist::Emit.dump(result))
            end
            queriesSchemes = result["LSApplicationQueriesSchemes"]
            if !queriesSchemes
                queriesSchemes = []
                result["LSApplicationQueriesSchemes"] = queriesSchemes
            end
            alipayQueriesSchemes = [
                "alipay",
            ]
            if alipayQueriesSchemes.any? { |queriesScheme| !(queriesSchemes.include? queriesScheme) }
                alipayQueriesSchemes.each do |queriesScheme|
                    if !(queriesSchemes.include? queriesScheme)
                        queriesSchemes << queriesScheme
                    end
                end
                File.write(infoplistFile, Plist::Emit.dump(result))
            end
            security = result["NSAppTransportSecurity"]
            if !security
                security = {}
                result["NSAppTransportSecurity"] = security
            end
            if security["NSAllowsArbitraryLoads"] != true
                security["NSAllowsArbitraryLoads"] = true
                File.write(infoplistFile, Plist::Emit.dump(result))
            end
            if security["NSAllowsArbitraryLoadsInWebContent"] != true
                security["NSAllowsArbitraryLoadsInWebContent"] = true
                File.write(infoplistFile, Plist::Emit.dump(result))
            end
        end
    end
end
