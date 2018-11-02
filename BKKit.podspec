#
#  Be sure to run `pod spec lint BKKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BKKit"
  s.version      = "0.0.1"
  s.summary      = "some common libs including categories for string,array,data...."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
		some common libs including categories for string,array,data....
                   DESC

  s.homepage     = "http://github.com/baboy/BKKit"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "baboy" => "baboyzyh@gmail.com" }
  # Or just: s.author    = "baboy"
  # s.authors            = { "baboy" => "baboyzyh@gmail.com" }
  # s.social_media_url   = "http://twitter.com/baboy"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/baboy/BKKit.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # s.source_files  = "BKKit","BKKit/modules","BKKit/modules/app","BKKit/modules/categories","BKKit/modules/controller","BKKit/modules/dao","BKKit/modules/ext","BKKit/modules/map","BKKit/modules/model","BKKit/modules/model/app","BKKit/modules/model/member","BKKit/modules/network","BKKit/modules/theme","BKKit/modules/ui","BKKit/modules/utils","BKKit/modules/vendor","BKKit/modules/vendor/AFNetworking","BKKit/modules/vendor/tracker","BKKit/modules/web"
  s.source_files  = "BKKit"
  # s.resource = "BKKit/modules/dao/db.plist"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "BKKit/BKKitDefines.h"
  s.subspec 'modules' do |mod|
      mod.subspec 'network' do |network|
        network.source_files = 'BKKit/modules/network'
        # utils.dependency "BKKit"
      end
      mod.subspec 'utils' do |utils|
        utils.source_files = 'BKKit/modules/utils'
        # utils.dependency "BKKit"
      end
      mod.subspec 'macro' do |macro|
        macro.source_files = 'BKKit/modules/macro'
      end
      mod.subspec 'categories' do |cate|
        cate.dependency "BKKit/modules/utils"
        cate.dependency "BKKit/modules/macro"
        cate.source_files = 'BKKit/modules/categories'
      end
      mod.subspec 'dao' do |dao|
        dao.dependency "BKKit/modules/utils"
        dao.dependency "BKKit/modules/categories"
        dao.dependency "BKKit/modules/macro"
        dao.source_files = 'BKKit/modules/dao'
        dao.resource = 'BKKit/modules/dao/db.plist'
      end

      mod.subspec 'app' do |app|
        app.dependency "BKKit/modules/utils"
        app.dependency "BKKit/modules/categories"
        app.dependency "BKKit/modules/macro"
        app.source_files = 'BKKit/modules/app'
        app.resource = 'BKKit/modules/app/default.api.plist','BKKit/modules/app/default.conf.plist'
      end
      
      mod.subspec 'lang' do |lang|
        lang.dependency "BKKit/modules/categories"
        lang.dependency "BKKit/modules/utils"
        lang.dependency "BKKit/modules/macro"
        lang.source_files = 'BKKit/modules/lang'
      end
      mod.subspec 'http' do |http|
        http.dependency "BKKit/modules/categories"
        http.dependency "BKKit/modules/utils"
        http.dependency "BKKit/modules/macro"
        http.dependency "BKKit/modules/lang"
        http.source_files = 'BKKit/modules/http'
      end

      mod.subspec 'ui' do |ui|

        ui.dependency "BKKit/modules/utils"
        ui.dependency "BKKit/modules/dao"
        ui.source_files = 'BKKit/modules/ui'

        ui.subspec "view" do |view|
          view.dependency "BKKit/modules/macro"
          view.source_files = 'BKKit/modules/ui/view'
        end

        ui.subspec 'complex' do |complex|
          complex.dependency "BKKit/modules/macro"
          complex.dependency "BKKit/modules/http"
          complex.dependency "BKKit/modules/ui/view"
          complex.source_files = 'BKKit/modules/ui/complex'
        end
      end
      mod.subspec 'map' do |map|
        map.dependency "BKKit/modules/ui/complex"
        map.dependency "BKKit/modules/macro"
        map.dependency "BKKit/modules/http"
        map.source_files = 'BKKit/modules/map'
      end


      mod.subspec 'ctx' do |ctx|
        ctx.dependency "BKKit/modules/utils"
        ctx.dependency "BKKit/modules/macro"
        ctx.dependency "BKKit/modules/dao"
        ctx.dependency "BKKit/modules/app"
        ctx.dependency "BKKit/modules/ui"
        ctx.dependency "BKKit/modules/ui/complex"
        ctx.source_files = 'BKKit/modules/ctx'

        ctx.subspec 'app' do |app|
          app.source_files = 'BKKit/modules/ctx/app'
        end
        ctx.subspec 'user' do |user|
          user.source_files = 'BKKit/modules/ctx/user'
        end
        ctx.subspec 'base' do |base|
          base.source_files = 'BKKit/modules/ctx/base'
        end

      end
  end


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  s.frameworks = 'UIKit', 'QuartzCore', 'CFNetwork', 'AVFoundation', 'CoreFoundation', 'CoreGraphics', 'Security', 'AudioToolbox', 'MediaPlayer', 'MobileCoreServices', 'SystemConfiguration', 'CoreMedia', 'Mapkit', 'CoreLocation', 'MessageUI', 'ImageIO'
  s.libraries   = 'sqlite3.0', 'xml2', 'icucore', 'z'

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.dependency 'Reachability'
  s.dependency 'FMDB'
  s.dependency 'RegexKitLite'
  s.dependency 'AFNetworking'
  s.dependency 'OpenUDID'


end
