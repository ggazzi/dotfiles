Config
  { font = "xft:fira sans-10:weight=bold:encoding=utf-8"
  , bgColor = "black"
  , fgColor = "grey"
  , position = TopW L 100
  , lowerOnStart = True
  , commands =
    [ Run Weather "KPAO" ["-t","<tempF>F <skyCondition>","-L","64","-H","77","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 36000
    , Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10
    , Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
    , Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10
    , Run Battery ["-t","<acstatus>","-L","25","-H","75","-l","#FFB6B0","-h","#CEFFAC","-n","#FFFFCC", "--", "-O", "Charging: <left>% (<timeleft>)", "-i", "Batt: <left>%", "-o", "Batt: <left>% (<timeleft>)"] 10
    , Run Date "%a %b %_d %H:%M" "date" 10
    , Run StdinReader
    ]
  , sepChar = "%"
  , alignSep = "}{"
  , template = "%StdinReader% }{ %multicpu%   %memory%   %swap%  %battery%   <fc=#FFFFCC>%date%</fc>   "
  }
