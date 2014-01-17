class Facts_fixture

 def version_resp
    return "TOP_6510:wv> version
Kernel:     2.6.14.2
Fabric OS:  v7.2.0a
Made on:    Mon Sep 9 17:08:27 2013
Flash:      Fri Dec 13 16:05:16 2013
BootProm:   1.0.11
TOP_6510:wv>"
  end

def memshow_resp
	return "
             total       used       free     shared    buffers     cached
Mem:    1048674304  373342208  675332096          0   38154240  131166208
Swap:            0          0          0
"
end

def switchstatusshow_resp
	return "
Switch Health Report                        Report time: 01/17/2014 11:41:17 AM
Switch Name:    TOP_6510
IP address:     172.17.10.15
SwitchState:    HEALTHY
Duration:       595:41

Power supplies monitor  HEALTHY
Temperatures monitor    HEALTHY
Fans monitor            HEALTHY
Flash monitor           HEALTHY
Marginal ports monitor  HEALTHY
Faulty ports monitor    HEALTHY
Missing SFPs monitor    HEALTHY
Error ports monitor     HEALTHY
Fabric Watch is not licensed
Detailed port information is not included

	"
end

def ipaddrshow_resp
	return "
SWITCH
Ethernet IP Address: 172.17.10.15
Ethernet Subnetmask: 255.255.0.0
Gateway IP Address: 172.17.0.1
DHCP: Off
TOP_6510:wv
"
end

 def chassisshow_resp
return	 "
TOP_6510:wv> chassisshow

FAN  Unit: 1
Fan Direction:          Forward
Time Awake:             24 days

FAN  Unit: 2
Fan Direction:          Forward
Time Awake:             24 days

POWER SUPPLY  Unit: 1
Power Source:           AC
Time Awake:             24 days

POWER SUPPLY  Unit: 2
Power Source:           AC
Time Awake:             24 days

CHASSIS/WWN  Unit: 1
Header Version:         2
Power Usage (Watts):    -56
Factory Part Num:       40-1000569-12
Factory Serial Num:     BRW2508J00H
Manufacture:            Day: 26  Month:  1  Year: 2013
Update:                 Day: 16  Month:  1  Year: 2014
Time Alive:             273 days
Time Awake:             24 days
ID:                     BRD0000CA
Part Num:               BROCAD0000651
Serial Num:             589Y7P1
"
end


 def switchshow_resp
	 return "
switchName:     TOP_6510
switchType:     109.1
switchState:    Online
switchMode:     Native
switchRole:     Principal
switchDomain:   1
switchId:       fffc01
switchWwn:      10:00:00:27:f8:61:7d:ba
zoning:         ON (Top_Config)
switchBeacon:   OFF
FC Router:      OFF
FC Router BB Fabric ID: 1
Address Mode:   0

Index Port Address Media Speed       State   Proto
==================================================
   0   0   010000   id    N8       Online      FC  F-Port  1 N Port + 2 NPIV pub                                                                                                                      lic
   1   1   010100   id    N8       Online      FC  F-Port  1 N Port + 1 NPIV pub                                                                                                                      lic
   2   2   010200   id    N8       Online      FC  F-Port  1 N Port + 2 NPIV pub                                                                                                                      lic
   3   3   010300   id    N8       Online      FC  F-Port  1 N Port + 3 NPIV pub                                                                                                                      lic
   4   4   010400   id    N8       No_Light    FC
   5   5   010500   id    N8       No_Light    FC
   6   6   010600   id    N8       No_Light    FC
   7   7   010700   id    N8       No_Light    FC
   8   8   010800   id    N8       No_Light    FC
   9   9   010900   id    N8       No_Light    FC
  10  10   010a00   id    N8       No_Light    FC
  11  11   010b00   id    N8       Online      FC  F-Port  21:00:00:24:ff:52:e6:                                                                                                                      46
  12  12   010c00   id    N8       No_Light    FC
  13  13   010d00   id    N8       No_Light    FC
  14  14   010e00   id    N8       No_Light    FC
  15  15   010f00   id    N8       No_Light    FC
  16  16   011000   id    N8       Online      FC  F-Port  50:00:d3:10:00:5e:c4:                                                                                                                      1d
  17  17   011100   id    N8       Online      FC  F-Port  50:00:d3:10:00:5e:c4:                                                                                                                      21
  18  18   011200   id    N8       Online      FC  F-Port  1 N Port + 2 NPIV pub                                                                                                                      lic
  19  19   011300   id    N8       Online      FC  F-Port  1 N Port + 2 NPIV pub                                                                                                                      lic
  20  20   011400   id    N8       No_Light    FC
  21  21   011500   id    N8       No_Light    FC
  22  22   011600   id    N8       No_Light    FC
  23  23   011700   id    N8       No_Light    FC
  24  24   011800   --    N16      No_Module   FC  (No POD License) Disabled
  25  25   011900   --    N16      No_Module   FC  (No POD License) Disabled
  26  26   011a00   --    N16      No_Module   FC  (No POD License) Disabled
  27  27   011b00   --    N16      No_Module   FC  (No POD License) Disabled
  28  28   011c00   --    N16      No_Module   FC  (No POD License) Disabled
  29  29   011d00   --    N16      No_Module   FC  (No POD License) Disabled
  30  30   011e00   --    N16      No_Module   FC  (No POD License) Disabled
  31  31   011f00   --    N16      No_Module   FC  (No POD License) Disabled
  32  32   012000   --    N16      No_Module   FC  (No POD License) Disabled
  33  33   012100   --    N16      No_Module   FC  (No POD License) Disabled
  34  34   012200   --    N16      No_Module   FC  (No POD License) Disabled
  35  35   012300   --    N16      No_Module   FC  (No POD License) Disabled
  36  36   012400   --    N16      No_Module   FC  (No POD License) Disabled
  37  37   012500   --    N16      No_Module   FC  (No POD License) Disabled
  38  38   012600   --    N16      No_Module   FC  (No POD License) Disabled
  39  39   012700   --    N16      No_Module   FC  (No POD License) Disabled
  40  40   012800   --    N16      No_Module   FC  (No POD License) Disabled
  41  41   012900   --    N16      No_Module   FC  (No POD License) Disabled
  42  42   012a00   --    N16      No_Module   FC  (No POD License) Disabled
  43  43   012b00   --    N16      No_Module   FC  (No POD License) Disabled
  44  44   012c00   --    N16      No_Module   FC  (No POD License) Disabled
  45  45   012d00   --    N16      No_Module   FC  (No POD License) Disabled
  46  46   012e00   --    N16      No_Module   FC  (No POD License) Disabled
"	
 end

 def zoneshow_resp
return "Defined configuration:
 cfg:   DemoConfig123
                DemoZone
 cfg:   DemoConfig1234
                DemoZone123456
 cfg:   DemoConfig31
                DemoZone31
 cfg:   TestCFG new
 cfg:   TestZone
                new; Zone_ASM_JK4V5Y1_B1; Zone_ASM_DP181Y1_B1
 cfg:   Test_Config
                Zone_ASM_JK4V5Y1_B1; new; Zone_ASM_2_B1
 cfg:   Top_Config
                ASM_ESXi_Host; Cntrl_Phys_Port; Cntrl_Virtual_Port; new;
                Zone_ASM_2L4V5Y1_B1; Zone_ASM_DP181Y1_B1; Zone_ASM_3_B1;
                Zone_ASM_4_B1; Zone_ASM_2_B1; Zone_ASM_JK4V5Y1_B1; DemoZone31
 cfg:   cfgAB   Zone_ASM_JK4V5Y1_B1; Zone_ASM_4_B1; new
 cfg:   democonfig
                DemoZone
 cfg:   democonfig11
                DemoZone
 cfg:   yahoo   new
 zone:  ASM_ESXi_Host
                20:00:00:24:ff:52:e6:46; 21:00:00:24:ff:52:e6:46;
                50:00:d3:10:00:5e:c4:35; 50:00:d3:10:00:5e:c4:37;
                50:00:d3:10:00:5e:c4:39; 50:00:d3:10:00:5e:c4:3b;
                Compellent_Top
 zone:  Cntrl_Phys_Port
                50:00:d3:10:00:5e:c4:05; 50:00:d3:10:00:5e:c4:09;
                50:00:d3:10:00:5e:c4:1d; 50:00:d3:10:00:5e:c4:21
 zone:  Cntrl_Virtual_Port
                Compellent_Top
 zone:  DemoZone31
                21:00:00:24:ff:4a:be:2e; Compellent_Top;
                50:00:d3:10:00:5e:c4:39
 zone:  Zone_ASM_2L4V5Y1_B1
                ASM_2L4V5Y1_B1; Compellent_Top
 zone:  Zone_ASM_2_B1
                Compellent_Top; ASM_2_B1
 zone:  Zone_ASM_3_B1
                Compellent_Top; ASM_3_B1
 zone:  Zone_ASM_3_B2
                Compellent_Bottom; ASM_3_B2
 zone:  Zone_ASM_4_B1
                Compellent_Top; ASM_4_B1
 zone:  Zone_ASM_4_B2
                Compellent_Bottom; ASM_4_B2
 zone:  Zone_ASM_DP181Y1_B1
                Compellent_Top; ASM_DP181Y1_B1
 zone:  Zone_ASM_JK4V5Y1_B1
                Compellent_Top; ASM_JK4V5Y1_B1
 zone:  new     20:00:00:24:ff:4a:bf:6c; 21:00:00:24:ff:4a:bf:6c;
                50:00:d3:10:00:5e:c4:35; 50:00:d3:10:00:5e:c4:37;
                50:00:d3:10:00:5e:c4:39; 50:00:d3:10:00:5e:c4:3b;
                0f:0a:0a:0a:0a:0a:0a:0b
 alias: ASM_15N71Y1_B1
                21:00:00:24:ff:4a:72:28
 alias: ASM_1L4V5Y1_22
                21:00:00:24:ff:4a:bf:6c
 alias: ASM_1L4V5Y1_B1
                21:00:00:24:ff:4a:bf:6c
 alias: ASM_201_B1
                21:00:00:24:ff:4a:bf:6c
 alias: ASM_202_B1
                21:00:00:24:ff:4a:72:08
 alias: ASM_203_B1
                21:00:00:24:ff:4a:bf:6c
 alias: ASM_204_B1
                21:00:00:24:ff:4a:72:08
 alias: ASM_25N71Y1_B1
                21:00:00:24:ff:4a:72:08
 alias: ASM_2L4V5Y1_B1
                20:00:00:24:ff:4a:bc:88; 21:00:00:24:ff:4a:bc:88
 alias: ASM_2_B1
                21:00:00:24:ff:4a:be:2e
 alias: ASM_3_B1
                21:00:00:24:ff:4a:bf:6c
 alias: ASM_3_B2
                21:00:00:24:ff:4a:bf:6d
 alias: ASM_4_B1
                21:00:00:24:ff:4a:72:08
 alias: ASM_4_B2
                21:00:00:24:ff:4a:72:09
 alias: ASM_CP181Y1_B1
                21:00:00:24:ff:4a:6c:44
 alias: ASM_DK4V5Y1_B1
                21:00:00:24:ff:4a:bb:5a
 alias: ASM_DP181Y1_B1
                21:00:00:24:ff:4a:6c:fc
 alias: ASM_FP181Y1_B1
                21:00:00:24:ff:44:48:6e
 alias: ASM_HK4V5Y1_B1
                21:00:00:24:ff:4a:be:2e
 alias: ASM_J4N71Y1_22
                21:00:00:24:ff:4a:70:92
 alias: ASM_J4N71Y1_B1
                21:00:00:24:ff:4a:70:92
 alias: ASM_JK4V5Y1_B1
                21:00:00:24:ff:4a:bb:3e
 alias: ASM__B1 21:00:00:24:ff:4a:bf:6c
 alias: Compellent_Top
                50:00:d3:10:00:5e:c4:35; 50:00:d3:10:00:5e:c4:37;
                50:00:d3:10:00:5e:c4:39; 50:00:d3:10:00:5e:c4:3b
 alias: Controller1_FC1
                50:00:d3:10:00:5e:c4:09
 alias: Controller1_FC2
                50:00:d3:10:00:5e:c4:0a
 alias: Controller1_FC3
                50:00:d3:10:00:5e:c4:05
 alias: Controller1_FC4
                50:00:d3:10:00:5e:c4:06
 alias: testalias11
                0f:0a:0a:0a:0a:0a:0a:0a
 alias: testalias81
                0f:0a:0a:0a:0a:0a:0a:0a

Effective configuration:
 cfg:   Top_Config
 zone:  ASM_ESXi_Host
                20:00:00:24:ff:52:e6:46
                21:00:00:24:ff:52:e6:46
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
 zone:  Cntrl_Phys_Port
                50:00:d3:10:00:5e:c4:05
                50:00:d3:10:00:5e:c4:09
                50:00:d3:10:00:5e:c4:1d
                50:00:d3:10:00:5e:c4:21
 zone:  Cntrl_Virtual_Port
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
 zone:  DemoZone31
                21:00:00:24:ff:4a:be:2e
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
 zone:  Zone_ASM_2L4V5Y1_B1
                20:00:00:24:ff:4a:bc:88
                21:00:00:24:ff:4a:bc:88
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
 zone:  Zone_ASM_2_B1
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
                21:00:00:24:ff:4a:be:2e
 zone:  Zone_ASM_3_B1
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
                21:00:00:24:ff:4a:bf:6c
 zone:  Zone_ASM_4_B1
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
                21:00:00:24:ff:4a:72:08
 zone:  Zone_ASM_DP181Y1_B1
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
                21:00:00:24:ff:4a:6c:fc
 zone:  Zone_ASM_JK4V5Y1_B1
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
                50:00:d3:10:00:5e:c4:3b
                21:00:00:24:ff:4a:bb:3e
 zone:  new     20:00:00:24:ff:4a:bf:6c
                21:00:00:24:ff:4a:bf:6c
                50:00:d3:10:00:5e:c4:35
                50:00:d3:10:00:5e:c4:37
                50:00:d3:10:00:5e:c4:39
"	 
end
end
