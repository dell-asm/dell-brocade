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
