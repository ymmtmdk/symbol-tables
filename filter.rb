#! /usr/bin/env ruby

ng = "
Using kotlin incremental compilation
[31mFAILURE: [39m[31mBuild failed with an exception.[39m
* What went wrong:
Execution failed for task ':compileTestKotlin'.
[33m> [39mCompilation error. See log for more details
* Try:
Run with [1m--stacktrace[m option to get the stack trace. Run with [1m--info[m or [1m--debug[m option to get more log output.
[33m> [39mThere were failing tests. See the report at: file:///home/gradle/app/build/reports/tests/test/index.html
Execution failed for task ':test'.
Waiting for changes to input files of tasks... (ctrl-d to exit)
".split(/\n/) - [""]

ls = %w(
:compileKotlin
:compileJava
:classes
:copyMainKotlinClasses
:copyTestKotlinClasses
:processResources
:compileTestKotlin
:compileTestJava
:processTestResources
:testClasses
:test
)
ng_reg = /^(#{ls.join('|')})( \[33m.+?\[39m)?(\[0K)?\z/

buf = ""
skip_blank = false
ARGF.each_char do |c|
  next if c == "\r"

  if c == "\n"
    case buf
    when /Continuous build is an incubating feature./
      print "[0m[1G[2K[34mBUILD START[39m\r\n"
    when /Change detected, executing build.../
      print "[0m[1G[2K[34mBUILD START[39m"
    when /BUILD FAILED/
      print "[2K[3F", buf
    when /BUILD SUCCESSFUL/
      print "\r\n[0m[1F", "[32mBUILD SUCCESSFUL[39m"
    when /Total time: .+ secs/
      print "[2K[1A[20G", buf#, "\r\n"
    else
      if ng.include?(buf) || buf =~ ng_reg
        print "[1G[2K[0m"
      else
        print "\r\n"
      end
    end
    buf = ""
  else
    buf += c
    print c
  end

  if buf =~ /\e\[1A\z/
    buf = ""
  end

  if buf.size % 50 == 49
    if ng.find{|s| s[0...buf.size] == buf}
      print "[2K[1G"
    end
  end
end

