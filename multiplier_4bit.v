/* Generated by Yosys 0.51+85 (git sha1 d3aec12fe, clang++ 18.1.8 -fPIC -O3) */

module multiplier(b, o, a);
  wire \$1 ;
  wire \$10 ;
  wire \$11 ;
  wire \$12 ;
  wire \$13 ;
  wire \$14 ;
  wire \$15 ;
  wire \$16 ;
  wire \$17 ;
  wire \$18 ;
  wire \$19 ;
  wire \$2 ;
  wire \$3 ;
  wire \$4 ;
  wire \$5 ;
  wire \$6 ;
  wire \$7 ;
  wire \$8 ;
  wire \$9 ;
  input [3:0] a;
  wire [3:0] a;
  wire [7:0] \a$91 ;
  wire [3:0] a_registered;
  input [3:0] b;
  wire [3:0] b;
  wire [7:0] \b$92 ;
  wire [3:0] b_registered;
  wire booth_b0_m0;
  wire booth_b0_m1;
  wire booth_b0_m2;
  wire booth_b0_m3;
  wire booth_b0_m4;
  wire booth_b2_m0;
  wire booth_b2_m1;
  wire booth_b2_m2;
  wire booth_b2_m3;
  wire booth_b2_m4;
  wire booth_b4_m0;
  wire booth_b4_m1;
  wire booth_b4_m2;
  wire booth_b4_m3;
  wire booth_b4_m4;
  wire [2:0] booth_block0;
  wire [1:0] booth_block0_mand0;
  wire [1:0] booth_block0_mand1;
  wire [1:0] booth_block0_mand2;
  wire [1:0] booth_block0_mand3;
  wire [1:0] booth_block0_mand4;
  wire [1:0] booth_block0_sel;
  wire booth_block0_sign;
  wire [2:0] booth_block2;
  wire [1:0] booth_block2_mand0;
  wire [1:0] booth_block2_mand1;
  wire [1:0] booth_block2_mand2;
  wire [1:0] booth_block2_mand3;
  wire [1:0] booth_block2_mand4;
  wire [1:0] booth_block2_sel;
  wire booth_block2_sign;
  wire [2:0] booth_block4;
  wire [1:0] booth_block4_mand0;
  wire [1:0] booth_block4_mand1;
  wire [1:0] booth_block4_mand2;
  wire [1:0] booth_block4_mand3;
  wire [1:0] booth_block4_mand4;
  wire [1:0] booth_block4_sel;
  wire booth_block4_sign;
  wire c;
  wire \c$78 ;
  wire \c$79 ;
  wire \c$80 ;
  wire \c$81 ;
  wire \c$82 ;
  wire con;
  wire \con$116 ;
  wire \con$118 ;
  wire \con$120 ;
  wire \con$122 ;
  wire \con$124 ;
  wire \con$126 ;
  wire [7:0] final_a_registered;
  wire [7:0] final_b_registered;
  wire [5:0] multiplicand;
  wire [6:0] multiplier;
  wire [2:0] notblock;
  wire [2:0] \notblock$102 ;
  wire [2:0] \notblock$108 ;
  wire notsign;
  wire \notsign$70 ;
  output [7:0] o;
  wire [7:0] o;
  wire [7:0] \o$94 ;
  wire pp_row0_0;
  wire pp_row0_1;
  wire pp_row1_0;
  wire pp_row2_0;
  wire pp_row2_1;
  wire pp_row2_2;
  wire pp_row3_0;
  wire pp_row3_1;
  wire pp_row4_0;
  wire pp_row4_1;
  wire pp_row4_2;
  wire pp_row5_0;
  wire pp_row5_1;
  wire pp_row5_2;
  wire pp_row6_0;
  wire pp_row6_1;
  wire pp_row6_2;
  wire pp_row7_0;
  wire pp_row7_1;
  wire pp_row7_2;
  wire pp_row8_0;
  wire pp_row8_1;
  wire [7:0] result;
  wire [7:0] result_registered;
  wire s;
  wire \s$85 ;
  wire \s$86 ;
  wire \s$87 ;
  wire \s$88 ;
  wire \s$89 ;
  wire \s$90 ;
  wire sel_0;
  wire \sel_0$20 ;
  wire \sel_0$30 ;
  wire sel_1;
  wire \sel_1$21 ;
  wire \sel_1$31 ;
  wire sn;
  wire \sn$117 ;
  wire \sn$119 ;
  wire \sn$121 ;
  wire \sn$123 ;
  wire \sn$125 ;
  wire \sn$127 ;
  wire t;
  wire \t$100 ;
  wire \t$101 ;
  wire \t$103 ;
  wire \t$104 ;
  wire \t$105 ;
  wire \t$106 ;
  wire \t$107 ;
  wire \t$109 ;
  wire \t$110 ;
  wire \t$111 ;
  wire \t$112 ;
  wire \t$113 ;
  wire \t$98 ;
  wire \t$99 ;
  INVx1_ASAP7_75t_R \U$10  (
    .A(a[1]),
    .Y(\$3 )
  );
  AO33x2_ASAP7_75t_R \U$11  (
    .A1(\$3 ),
    .A2(a[0]),
    .A3(1'h0),
    .B1(a[1]),
    .B2(\$2 ),
    .B3(\$1 ),
    .Y(sel_0)
  );
  XOR2x1_ASAP7_75t_R \U$12  (
    .A(a[0]),
    .B(1'h0),
    .Y(sel_1)
  );
  AO22x1_ASAP7_75t_R \U$13  (
    .A1(1'h0),
    .A2(sel_0),
    .B1(b[0]),
    .B2(sel_1),
    .Y(t)
  );
  XOR2x1_ASAP7_75t_R \U$14  (
    .A(t),
    .B(a[1]),
    .Y(pp_row0_0)
  );
  AO22x1_ASAP7_75t_R \U$15  (
    .A1(b[0]),
    .A2(sel_0),
    .B1(b[1]),
    .B2(sel_1),
    .Y(\t$98 )
  );
  XOR2x1_ASAP7_75t_R \U$16  (
    .A(\t$98 ),
    .B(a[1]),
    .Y(pp_row1_0)
  );
  AO22x1_ASAP7_75t_R \U$17  (
    .A1(b[1]),
    .A2(sel_0),
    .B1(b[2]),
    .B2(sel_1),
    .Y(\t$99 )
  );
  XOR2x1_ASAP7_75t_R \U$18  (
    .A(\t$99 ),
    .B(a[1]),
    .Y(pp_row2_0)
  );
  AO22x1_ASAP7_75t_R \U$19  (
    .A1(b[2]),
    .A2(sel_0),
    .B1(b[3]),
    .B2(sel_1),
    .Y(\t$100 )
  );
  XOR2x1_ASAP7_75t_R \U$20  (
    .A(\t$100 ),
    .B(a[1]),
    .Y(pp_row3_0)
  );
  AO22x1_ASAP7_75t_R \U$21  (
    .A1(b[3]),
    .A2(sel_0),
    .B1(1'h0),
    .B2(sel_1),
    .Y(\t$101 )
  );
  XOR2x1_ASAP7_75t_R \U$22  (
    .A(\t$101 ),
    .B(a[1]),
    .Y(pp_row4_0)
  );
  INVx1_ASAP7_75t_R \U$23  (
    .A(a[1]),
    .Y(pp_row7_0)
  );
  INVx1_ASAP7_75t_R \U$24  (
    .A(a[1]),
    .Y(\$4 )
  );
  INVx1_ASAP7_75t_R \U$25  (
    .A(a[2]),
    .Y(\$5 )
  );
  INVx1_ASAP7_75t_R \U$26  (
    .A(a[3]),
    .Y(\$6 )
  );
  AO33x2_ASAP7_75t_R \U$27  (
    .A1(\$6 ),
    .A2(a[2]),
    .A3(a[1]),
    .B1(a[3]),
    .B2(\$5 ),
    .B3(\$4 ),
    .Y(\sel_0$20 )
  );
  XOR2x1_ASAP7_75t_R \U$28  (
    .A(a[2]),
    .B(a[1]),
    .Y(\sel_1$21 )
  );
  AO22x1_ASAP7_75t_R \U$29  (
    .A1(1'h0),
    .A2(\sel_0$20 ),
    .B1(b[0]),
    .B2(\sel_1$21 ),
    .Y(\t$103 )
  );
  XOR2x1_ASAP7_75t_R \U$30  (
    .A(\t$103 ),
    .B(a[3]),
    .Y(pp_row2_1)
  );
  AO22x1_ASAP7_75t_R \U$31  (
    .A1(b[0]),
    .A2(\sel_0$20 ),
    .B1(b[1]),
    .B2(\sel_1$21 ),
    .Y(\t$104 )
  );
  XOR2x1_ASAP7_75t_R \U$32  (
    .A(\t$104 ),
    .B(a[3]),
    .Y(pp_row3_1)
  );
  AO22x1_ASAP7_75t_R \U$33  (
    .A1(b[1]),
    .A2(\sel_0$20 ),
    .B1(b[2]),
    .B2(\sel_1$21 ),
    .Y(\t$105 )
  );
  XOR2x1_ASAP7_75t_R \U$34  (
    .A(\t$105 ),
    .B(a[3]),
    .Y(pp_row4_1)
  );
  AO22x1_ASAP7_75t_R \U$35  (
    .A1(b[2]),
    .A2(\sel_0$20 ),
    .B1(b[3]),
    .B2(\sel_1$21 ),
    .Y(\t$106 )
  );
  XOR2x1_ASAP7_75t_R \U$36  (
    .A(\t$106 ),
    .B(a[3]),
    .Y(pp_row5_1)
  );
  AO22x1_ASAP7_75t_R \U$37  (
    .A1(b[3]),
    .A2(\sel_0$20 ),
    .B1(1'h0),
    .B2(\sel_1$21 ),
    .Y(\t$107 )
  );
  XOR2x1_ASAP7_75t_R \U$38  (
    .A(\t$107 ),
    .B(a[3]),
    .Y(pp_row6_1)
  );
  INVx1_ASAP7_75t_R \U$39  (
    .A(a[3]),
    .Y(pp_row7_1)
  );
  INVx1_ASAP7_75t_R \U$40  (
    .A(a[3]),
    .Y(\$7 )
  );
  INVx1_ASAP7_75t_R \U$41  (
    .A(1'h0),
    .Y(\$8 )
  );
  INVx1_ASAP7_75t_R \U$42  (
    .A(1'h0),
    .Y(\$9 )
  );
  AO33x2_ASAP7_75t_R \U$43  (
    .A1(\$9 ),
    .A2(1'h0),
    .A3(a[3]),
    .B1(1'h0),
    .B2(\$8 ),
    .B3(\$7 ),
    .Y(\sel_0$30 )
  );
  XOR2x1_ASAP7_75t_R \U$44  (
    .A(1'h0),
    .B(a[3]),
    .Y(\sel_1$31 )
  );
  AO22x1_ASAP7_75t_R \U$45  (
    .A1(1'h0),
    .A2(\sel_0$30 ),
    .B1(b[0]),
    .B2(\sel_1$31 ),
    .Y(\t$109 )
  );
  XOR2x1_ASAP7_75t_R \U$46  (
    .A(\t$109 ),
    .B(1'h0),
    .Y(pp_row4_2)
  );
  AO22x1_ASAP7_75t_R \U$47  (
    .A1(b[0]),
    .A2(\sel_0$30 ),
    .B1(b[1]),
    .B2(\sel_1$31 ),
    .Y(\t$110 )
  );
  XOR2x1_ASAP7_75t_R \U$48  (
    .A(\t$110 ),
    .B(1'h0),
    .Y(pp_row5_2)
  );
  AO22x1_ASAP7_75t_R \U$49  (
    .A1(b[1]),
    .A2(\sel_0$30 ),
    .B1(b[2]),
    .B2(\sel_1$31 ),
    .Y(\t$111 )
  );
  XOR2x1_ASAP7_75t_R \U$50  (
    .A(\t$111 ),
    .B(1'h0),
    .Y(pp_row6_2)
  );
  AO22x1_ASAP7_75t_R \U$51  (
    .A1(b[2]),
    .A2(\sel_0$30 ),
    .B1(b[3]),
    .B2(\sel_1$31 ),
    .Y(\t$112 )
  );
  XOR2x1_ASAP7_75t_R \U$52  (
    .A(\t$112 ),
    .B(1'h0),
    .Y(pp_row7_2)
  );
  AO22x1_ASAP7_75t_R \U$53  (
    .A1(b[3]),
    .A2(\sel_0$30 ),
    .B1(1'h0),
    .B2(\sel_1$31 ),
    .Y(\t$113 )
  );
  XOR2x1_ASAP7_75t_R \U$54  (
    .A(\t$113 ),
    .B(1'h0),
    .Y(pp_row8_1)
  );
  INVx1_ASAP7_75t_R \U$55  (
    .A(1'h0),
    .Y(\$10 )
  );
  INVx1_ASAP7_75t_R \U$56  (
    .A(con),
    .Y(c)
  );
  INVx1_ASAP7_75t_R \U$57  (
    .A(sn),
    .Y(s)
  );
  INVx1_ASAP7_75t_R \U$58  (
    .A(\con$116 ),
    .Y(\c$78 )
  );
  INVx1_ASAP7_75t_R \U$59  (
    .A(\sn$117 ),
    .Y(\s$85 )
  );
  INVx1_ASAP7_75t_R \U$60  (
    .A(\con$118 ),
    .Y(\c$79 )
  );
  INVx1_ASAP7_75t_R \U$61  (
    .A(\sn$119 ),
    .Y(\s$86 )
  );
  INVx1_ASAP7_75t_R \U$62  (
    .A(\con$120 ),
    .Y(\c$80 )
  );
  INVx1_ASAP7_75t_R \U$63  (
    .A(\sn$121 ),
    .Y(\s$87 )
  );
  INVx1_ASAP7_75t_R \U$64  (
    .A(\con$122 ),
    .Y(\c$81 )
  );
  INVx1_ASAP7_75t_R \U$65  (
    .A(\sn$123 ),
    .Y(\s$88 )
  );
  INVx1_ASAP7_75t_R \U$66  (
    .A(\con$124 ),
    .Y(\c$82 )
  );
  INVx1_ASAP7_75t_R \U$67  (
    .A(\sn$125 ),
    .Y(\s$89 )
  );
  INVx1_ASAP7_75t_R \U$68  (
    .A(\con$126 ),
    .Y(\$11 )
  );
  INVx1_ASAP7_75t_R \U$69  (
    .A(\sn$127 ),
    .Y(\s$90 )
  );
  INVx1_ASAP7_75t_R \U$8  (
    .A(1'h0),
    .Y(\$1 )
  );
  INVx1_ASAP7_75t_R \U$9  (
    .A(a[0]),
    .Y(\$2 )
  );
  FAx1_ASAP7_75t_R dadda_fa_0_4_0 (
    .A(pp_row4_0),
    .B(pp_row4_1),
    .CI(pp_row4_2),
    .CON(\con$118 ),
    .SN(\sn$119 )
  );
  FAx1_ASAP7_75t_R dadda_fa_0_5_0 (
    .A(a[1]),
    .B(pp_row5_1),
    .CI(pp_row5_2),
    .CON(\con$120 ),
    .SN(\sn$121 )
  );
  FAx1_ASAP7_75t_R dadda_fa_0_6_0 (
    .A(a[1]),
    .B(pp_row6_1),
    .CI(pp_row6_2),
    .CON(\con$122 ),
    .SN(\sn$123 )
  );
  FAx1_ASAP7_75t_R dadda_fa_0_7_0 (
    .A(pp_row7_0),
    .B(pp_row7_1),
    .CI(pp_row7_2),
    .CON(\con$124 ),
    .SN(\sn$125 )
  );
  HAxp5_ASAP7_75t_R dadda_ha_0_2_0 (
    .A(pp_row2_0),
    .B(pp_row2_1),
    .CON(con),
    .SN(sn)
  );
  HAxp5_ASAP7_75t_R dadda_ha_0_3_0 (
    .A(pp_row3_0),
    .B(pp_row3_1),
    .CON(\con$116 ),
    .SN(\sn$117 )
  );
  HAxp5_ASAP7_75t_R dadda_ha_0_8_0 (
    .A(1'h1),
    .B(pp_row8_1),
    .CON(\con$126 ),
    .SN(\sn$127 )
  );
  \multiplier.final_adder  final_adder (
    .\port$0$3 (a[1]),
    .\port$0$5 (a[3]),
    .\port$122$0 (c),
    .\port$123$0 (s),
    .\port$124$0 (\c$78 ),
    .\port$125$0 (\s$85 ),
    .\port$126$0 (\c$79 ),
    .\port$127$0 (\s$86 ),
    .\port$128$0 (\c$80 ),
    .\port$129$0 (\s$87 ),
    .\port$130$0 (\c$81 ),
    .\port$131$0 (\s$88 ),
    .\port$133$0 (\s$89 ),
    .\port$66$0 (\$12 ),
    .\port$67$0 (\$13 ),
    .\port$68$0 (\$14 ),
    .\port$69$0 (\$15 ),
    .\port$70$0 (\$16 ),
    .\port$71$0 (\$17 ),
    .\port$72$0 (\$18 ),
    .\port$73$0 (\$19 ),
    .\port$80$0 (pp_row0_0),
    .\port$82$0 (pp_row1_0)
  );
  assign a_registered = a;
  assign b_registered = b;
  assign multiplier = { 2'h0, a, 1'h0 };
  assign multiplicand = { 1'h0, b, 1'h0 };
  assign booth_block0 = { a[1:0], 1'h0 };
  assign booth_block0_sign = a[1];
  assign booth_block0_sel = { sel_1, sel_0 };
  assign booth_block0_mand0 = { b[0], 1'h0 };
  assign booth_block0_mand1 = b[1:0];
  assign booth_block0_mand2 = b[2:1];
  assign booth_block0_mand3 = b[3:2];
  assign booth_block0_mand4 = { 1'h0, b[3] };
  assign booth_block2 = a[3:1];
  assign booth_block2_sign = a[3];
  assign booth_block2_sel = { \sel_1$21 , \sel_0$20  };
  assign booth_block2_mand0 = { b[0], 1'h0 };
  assign booth_block2_mand1 = b[1:0];
  assign booth_block2_mand2 = b[2:1];
  assign booth_block2_mand3 = b[3:2];
  assign booth_block2_mand4 = { 1'h0, b[3] };
  assign booth_block4 = { 2'h0, a[3] };
  assign booth_block4_sign = 1'h0;
  assign booth_block4_sel = { \sel_1$31 , \sel_0$30  };
  assign booth_block4_mand0 = { b[0], 1'h0 };
  assign booth_block4_mand1 = b[1:0];
  assign booth_block4_mand2 = b[2:1];
  assign booth_block4_mand3 = b[3:2];
  assign booth_block4_mand4 = { 1'h0, b[3] };
  assign booth_b0_m0 = pp_row0_0;
  assign pp_row0_1 = a[1];
  assign booth_b0_m1 = pp_row1_0;
  assign booth_b0_m2 = pp_row2_0;
  assign booth_b2_m0 = pp_row2_1;
  assign pp_row2_2 = a[3];
  assign booth_b0_m3 = pp_row3_0;
  assign booth_b2_m1 = pp_row3_1;
  assign booth_b0_m4 = pp_row4_0;
  assign booth_b2_m2 = pp_row4_1;
  assign booth_b4_m0 = pp_row4_2;
  assign pp_row5_0 = a[1];
  assign booth_b2_m3 = pp_row5_1;
  assign booth_b4_m1 = pp_row5_2;
  assign pp_row6_0 = a[1];
  assign booth_b2_m4 = pp_row6_1;
  assign booth_b4_m2 = pp_row6_2;
  assign notsign = pp_row7_0;
  assign \notsign$70  = pp_row7_1;
  assign booth_b4_m3 = pp_row7_2;
  assign pp_row8_0 = 1'h1;
  assign booth_b4_m4 = pp_row8_1;
  assign final_a_registered = { \c$81 , \c$80 , \c$79 , \c$78 , c, a[3], pp_row1_0, pp_row0_0 };
  assign final_b_registered = { \s$89 , \s$88 , \s$87 , \s$86 , \s$85 , s, 1'h0, a[1] };
  assign \a$91  = { \c$81 , \c$80 , \c$79 , \c$78 , c, a[3], pp_row1_0, pp_row0_0 };
  assign \b$92  = { \s$89 , \s$88 , \s$87 , \s$86 , \s$85 , s, 1'h0, a[1] };
  assign result = { \$19 , \$18 , \$17 , \$16 , \$15 , \$14 , \$13 , \$12  };
  assign \o$94  = { \$19 , \$18 , \$17 , \$16 , \$15 , \$14 , \$13 , \$12  };
  assign result_registered = { \$19 , \$18 , \$17 , \$16 , \$15 , \$14 , \$13 , \$12  };
  assign notblock = { \$3 , \$2 , \$1  };
  assign \notblock$102  = { \$6 , \$5 , \$4  };
  assign \notblock$108  = { \$9 , \$8 , \$7  };
  assign o = { \$19 , \$18 , \$17 , \$16 , \$15 , \$14 , \$13 , \$12  };
endmodule

module \multiplier.final_adder (\port$0$5 , \port$66$0 , \port$67$0 , \port$68$0 , \port$69$0 , \port$70$0 , \port$71$0 , \port$72$0 , \port$73$0 , \port$80$0 , \port$82$0 , \port$122$0 , \port$123$0 , \port$124$0 , \port$125$0 , \port$126$0 , \port$127$0 , \port$128$0 , \port$129$0 , \port$130$0 , \port$131$0 
, \port$133$0 , \port$0$3 );
  wire \$1 ;
  wire \$10 ;
  wire \$11 ;
  wire \$12 ;
  wire \$13 ;
  wire \$2 ;
  wire \$3 ;
  wire \$4 ;
  wire \$5 ;
  wire \$6 ;
  wire \$7 ;
  wire \$8 ;
  wire \$9 ;
  wire \$signal ;
  wire \$signal$10 ;
  wire \$signal$11 ;
  wire \$signal$12 ;
  wire \$signal$13 ;
  wire \$signal$14 ;
  wire \$signal$15 ;
  wire \$signal$16 ;
  wire \$signal$17 ;
  wire \$signal$18 ;
  wire \$signal$19 ;
  wire \$signal$39 ;
  wire \$signal$40 ;
  wire \$signal$41 ;
  wire \$signal$42 ;
  wire \$signal$43 ;
  wire \$signal$44 ;
  wire \$signal$45 ;
  wire \$signal$46 ;
  wire \$signal$5 ;
  wire \$signal$6 ;
  wire \$signal$7 ;
  wire \$signal$8 ;
  wire \$signal$9 ;
  wire [7:0] a;
  wire [7:0] \a$1 ;
  wire [7:0] b;
  wire [7:0] \b$3 ;
  wire con;
  wire \con$25 ;
  wire \con$27 ;
  wire \con$29 ;
  wire \con$31 ;
  wire \con$33 ;
  wire \con$35 ;
  wire \con$37 ;
  wire g_new;
  wire \g_new$50 ;
  wire \g_new$53 ;
  wire \g_new$54 ;
  wire \g_new$56 ;
  wire \g_new$58 ;
  wire \g_new$60 ;
  wire \g_new$63 ;
  wire \g_new$64 ;
  wire \g_new$67 ;
  wire \g_new$68 ;
  wire \g_new$70 ;
  wire \g_new$72 ;
  wire \g_new$73 ;
  wire \g_new$74 ;
  wire \g_new$75 ;
  wire [7:0] o;
  wire [7:0] \o$22 ;
  wire [7:0] o2;
  wire p_new;
  wire \p_new$48 ;
  wire \p_new$51 ;
  wire \p_new$52 ;
  wire \p_new$55 ;
  wire \p_new$57 ;
  wire \p_new$59 ;
  wire \p_new$61 ;
  wire \p_new$62 ;
  wire \p_new$65 ;
  wire \p_new$66 ;
  wire \p_new$69 ;
  wire \p_new$71 ;
  input \port$0$3 ;
  wire \port$0$3 ;
  input \port$0$5 ;
  wire \port$0$5 ;
  input \port$122$0 ;
  wire \port$122$0 ;
  input \port$123$0 ;
  wire \port$123$0 ;
  input \port$124$0 ;
  wire \port$124$0 ;
  input \port$125$0 ;
  wire \port$125$0 ;
  input \port$126$0 ;
  wire \port$126$0 ;
  input \port$127$0 ;
  wire \port$127$0 ;
  input \port$128$0 ;
  wire \port$128$0 ;
  input \port$129$0 ;
  wire \port$129$0 ;
  input \port$130$0 ;
  wire \port$130$0 ;
  input \port$131$0 ;
  wire \port$131$0 ;
  input \port$133$0 ;
  wire \port$133$0 ;
  output \port$66$0 ;
  wire \port$66$0 ;
  output \port$67$0 ;
  wire \port$67$0 ;
  output \port$68$0 ;
  wire \port$68$0 ;
  output \port$69$0 ;
  wire \port$69$0 ;
  output \port$70$0 ;
  wire \port$70$0 ;
  output \port$71$0 ;
  wire \port$71$0 ;
  output \port$72$0 ;
  wire \port$72$0 ;
  output \port$73$0 ;
  wire \port$73$0 ;
  input \port$80$0 ;
  wire \port$80$0 ;
  input \port$82$0 ;
  wire \port$82$0 ;
  wire sn;
  wire \sn$26 ;
  wire \sn$28 ;
  wire \sn$30 ;
  wire \sn$32 ;
  wire \sn$34 ;
  wire \sn$36 ;
  wire \sn$38 ;
  HAxp5_ASAP7_75t_R \U$0  (
    .A(\port$80$0 ),
    .B(\port$0$3 ),
    .CON(con),
    .SN(sn)
  );
  INVx1_ASAP7_75t_R \U$1  (
    .A(con),
    .Y(\$signal$46 )
  );
  INVx1_ASAP7_75t_R \U$10  (
    .A(\con$29 ),
    .Y(\$signal$43 )
  );
  INVx1_ASAP7_75t_R \U$11  (
    .A(\sn$30 ),
    .Y(\$signal$10 )
  );
  HAxp5_ASAP7_75t_R \U$12  (
    .A(\port$124$0 ),
    .B(\port$127$0 ),
    .CON(\con$31 ),
    .SN(\sn$32 )
  );
  INVx1_ASAP7_75t_R \U$13  (
    .A(\con$31 ),
    .Y(\$signal$42 )
  );
  INVx1_ASAP7_75t_R \U$14  (
    .A(\sn$32 ),
    .Y(\$signal$12 )
  );
  HAxp5_ASAP7_75t_R \U$15  (
    .A(\port$126$0 ),
    .B(\port$129$0 ),
    .CON(\con$33 ),
    .SN(\sn$34 )
  );
  INVx1_ASAP7_75t_R \U$16  (
    .A(\con$33 ),
    .Y(\$signal$41 )
  );
  INVx1_ASAP7_75t_R \U$17  (
    .A(\sn$34 ),
    .Y(\$signal$14 )
  );
  HAxp5_ASAP7_75t_R \U$18  (
    .A(\port$128$0 ),
    .B(\port$131$0 ),
    .CON(\con$35 ),
    .SN(\sn$36 )
  );
  INVx1_ASAP7_75t_R \U$19  (
    .A(\con$35 ),
    .Y(\$signal$39 )
  );
  INVx1_ASAP7_75t_R \U$2  (
    .A(sn),
    .Y(\$signal )
  );
  INVx1_ASAP7_75t_R \U$20  (
    .A(\sn$36 ),
    .Y(\$signal$16 )
  );
  HAxp5_ASAP7_75t_R \U$21  (
    .A(\port$130$0 ),
    .B(\port$133$0 ),
    .CON(\con$37 ),
    .SN(\sn$38 )
  );
  INVx1_ASAP7_75t_R \U$22  (
    .A(\con$37 ),
    .Y(\$signal$40 )
  );
  INVx1_ASAP7_75t_R \U$23  (
    .A(\sn$38 ),
    .Y(\$signal$18 )
  );
  AND2x2_ASAP7_75t_R \U$24  (
    .A(\$signal$16 ),
    .B(\$signal$18 ),
    .Y(\p_new$48 )
  );
  AO21x1_ASAP7_75t_R \U$25  (
    .A1(\$signal$18 ),
    .A2(\$signal$39 ),
    .B(\$signal$40 ),
    .Y(\g_new$50 )
  );
  AND2x2_ASAP7_75t_R \U$26  (
    .A(\$signal$14 ),
    .B(\$signal$16 ),
    .Y(\p_new$52 )
  );
  AO21x1_ASAP7_75t_R \U$27  (
    .A1(\$signal$16 ),
    .A2(\$signal$41 ),
    .B(\$signal$39 ),
    .Y(\g_new$54 )
  );
  AND2x2_ASAP7_75t_R \U$28  (
    .A(\$signal$12 ),
    .B(\$signal$14 ),
    .Y(p_new)
  );
  AO21x1_ASAP7_75t_R \U$29  (
    .A1(\$signal$14 ),
    .A2(\$signal$42 ),
    .B(\$signal$41 ),
    .Y(g_new)
  );
  HAxp5_ASAP7_75t_R \U$3  (
    .A(\port$82$0 ),
    .B(1'h0),
    .CON(\con$25 ),
    .SN(\sn$26 )
  );
  AND2x2_ASAP7_75t_R \U$30  (
    .A(\$signal$10 ),
    .B(\$signal$12 ),
    .Y(\p_new$51 )
  );
  AO21x1_ASAP7_75t_R \U$31  (
    .A1(\$signal$12 ),
    .A2(\$signal$43 ),
    .B(\$signal$42 ),
    .Y(\g_new$53 )
  );
  AND2x2_ASAP7_75t_R \U$32  (
    .A(\$signal$8 ),
    .B(\$signal$10 ),
    .Y(\p_new$55 )
  );
  AO21x1_ASAP7_75t_R \U$33  (
    .A1(\$signal$10 ),
    .A2(\$signal$44 ),
    .B(\$signal$43 ),
    .Y(\g_new$56 )
  );
  AND2x2_ASAP7_75t_R \U$34  (
    .A(\$signal$6 ),
    .B(\$signal$8 ),
    .Y(\p_new$57 )
  );
  AO21x1_ASAP7_75t_R \U$35  (
    .A1(\$signal$8 ),
    .A2(\$signal$45 ),
    .B(\$signal$44 ),
    .Y(\g_new$58 )
  );
  AND2x2_ASAP7_75t_R \U$36  (
    .A(\$signal ),
    .B(\$signal$6 ),
    .Y(\p_new$59 )
  );
  AO21x1_ASAP7_75t_R \U$37  (
    .A1(\$signal$6 ),
    .A2(\$signal$46 ),
    .B(\$signal$45 ),
    .Y(\g_new$60 )
  );
  AND2x2_ASAP7_75t_R \U$38  (
    .A(p_new),
    .B(\p_new$48 ),
    .Y(\p_new$62 )
  );
  AO21x1_ASAP7_75t_R \U$39  (
    .A1(\p_new$48 ),
    .A2(g_new),
    .B(\g_new$50 ),
    .Y(\g_new$64 )
  );
  INVx1_ASAP7_75t_R \U$4  (
    .A(\con$25 ),
    .Y(\$signal$45 )
  );
  AND2x2_ASAP7_75t_R \U$40  (
    .A(\p_new$51 ),
    .B(\p_new$52 ),
    .Y(\p_new$66 )
  );
  AO21x1_ASAP7_75t_R \U$41  (
    .A1(\p_new$52 ),
    .A2(\g_new$53 ),
    .B(\g_new$54 ),
    .Y(\g_new$68 )
  );
  AND2x2_ASAP7_75t_R \U$42  (
    .A(\p_new$55 ),
    .B(p_new),
    .Y(\p_new$69 )
  );
  AO21x1_ASAP7_75t_R \U$43  (
    .A1(p_new),
    .A2(\g_new$56 ),
    .B(g_new),
    .Y(\g_new$70 )
  );
  AND2x2_ASAP7_75t_R \U$44  (
    .A(\p_new$57 ),
    .B(\p_new$51 ),
    .Y(\p_new$71 )
  );
  AO21x1_ASAP7_75t_R \U$45  (
    .A1(\p_new$51 ),
    .A2(\g_new$58 ),
    .B(\g_new$53 ),
    .Y(\g_new$72 )
  );
  AND2x2_ASAP7_75t_R \U$46  (
    .A(\p_new$59 ),
    .B(\p_new$55 ),
    .Y(\p_new$61 )
  );
  AO21x1_ASAP7_75t_R \U$47  (
    .A1(\p_new$55 ),
    .A2(\g_new$60 ),
    .B(\g_new$56 ),
    .Y(\g_new$63 )
  );
  AND2x2_ASAP7_75t_R \U$48  (
    .A(\$signal ),
    .B(\p_new$57 ),
    .Y(\p_new$65 )
  );
  AO21x1_ASAP7_75t_R \U$49  (
    .A1(\p_new$57 ),
    .A2(\$signal$46 ),
    .B(\g_new$58 ),
    .Y(\g_new$67 )
  );
  INVx1_ASAP7_75t_R \U$5  (
    .A(\sn$26 ),
    .Y(\$signal$6 )
  );
  AND2x2_ASAP7_75t_R \U$50  (
    .A(\p_new$61 ),
    .B(\p_new$62 ),
    .Y(\$1 )
  );
  AO21x1_ASAP7_75t_R \U$51  (
    .A1(\p_new$62 ),
    .A2(\g_new$63 ),
    .B(\g_new$64 ),
    .Y(\$2 )
  );
  AND2x2_ASAP7_75t_R \U$52  (
    .A(\p_new$65 ),
    .B(\p_new$66 ),
    .Y(\$3 )
  );
  AO21x1_ASAP7_75t_R \U$53  (
    .A1(\p_new$66 ),
    .A2(\g_new$67 ),
    .B(\g_new$68 ),
    .Y(\g_new$75 )
  );
  AND2x2_ASAP7_75t_R \U$54  (
    .A(\p_new$59 ),
    .B(\p_new$69 ),
    .Y(\$4 )
  );
  AO21x1_ASAP7_75t_R \U$55  (
    .A1(\p_new$69 ),
    .A2(\g_new$60 ),
    .B(\g_new$70 ),
    .Y(\g_new$74 )
  );
  AND2x2_ASAP7_75t_R \U$56  (
    .A(\$signal ),
    .B(\p_new$71 ),
    .Y(\$5 )
  );
  AO21x1_ASAP7_75t_R \U$57  (
    .A1(\p_new$71 ),
    .A2(\$signal$46 ),
    .B(\g_new$72 ),
    .Y(\g_new$73 )
  );
  XOR2x1_ASAP7_75t_R \U$58  (
    .A(\$signal ),
    .B(1'h0),
    .Y(\$6 )
  );
  XOR2x1_ASAP7_75t_R \U$59  (
    .A(\$signal$6 ),
    .B(\$signal$46 ),
    .Y(\$7 )
  );
  HAxp5_ASAP7_75t_R \U$6  (
    .A(\port$0$5 ),
    .B(\port$123$0 ),
    .CON(\con$27 ),
    .SN(\sn$28 )
  );
  XOR2x1_ASAP7_75t_R \U$60  (
    .A(\$signal$8 ),
    .B(\g_new$60 ),
    .Y(\$8 )
  );
  XOR2x1_ASAP7_75t_R \U$61  (
    .A(\$signal$10 ),
    .B(\g_new$67 ),
    .Y(\$9 )
  );
  XOR2x1_ASAP7_75t_R \U$62  (
    .A(\$signal$12 ),
    .B(\g_new$63 ),
    .Y(\$10 )
  );
  XOR2x1_ASAP7_75t_R \U$63  (
    .A(\$signal$14 ),
    .B(\g_new$73 ),
    .Y(\$11 )
  );
  XOR2x1_ASAP7_75t_R \U$64  (
    .A(\$signal$16 ),
    .B(\g_new$74 ),
    .Y(\$12 )
  );
  XOR2x1_ASAP7_75t_R \U$65  (
    .A(\$signal$18 ),
    .B(\g_new$75 ),
    .Y(\$13 )
  );
  INVx1_ASAP7_75t_R \U$7  (
    .A(\con$27 ),
    .Y(\$signal$44 )
  );
  INVx1_ASAP7_75t_R \U$8  (
    .A(\sn$28 ),
    .Y(\$signal$8 )
  );
  HAxp5_ASAP7_75t_R \U$9  (
    .A(\port$122$0 ),
    .B(\port$125$0 ),
    .CON(\con$29 ),
    .SN(\sn$30 )
  );
  assign a = { \port$130$0 , \port$128$0 , \port$126$0 , \port$124$0 , \port$122$0 , \port$0$5 , \port$82$0 , \port$80$0  };
  assign \a$1  = { \port$130$0 , \port$128$0 , \port$126$0 , \port$124$0 , \port$122$0 , \port$0$5 , \port$82$0 , \port$80$0  };
  assign b = { \port$133$0 , \port$131$0 , \port$129$0 , \port$127$0 , \port$125$0 , \port$123$0 , 1'h0, \port$0$3  };
  assign \b$3  = { \port$133$0 , \port$131$0 , \port$129$0 , \port$127$0 , \port$125$0 , \port$123$0 , 1'h0, \port$0$3  };
  assign \$signal$5  = \$signal ;
  assign \$signal$7  = \$signal$6 ;
  assign \$signal$9  = \$signal$8 ;
  assign \$signal$11  = \$signal$10 ;
  assign \$signal$13  = \$signal$12 ;
  assign \$signal$15  = \$signal$14 ;
  assign \$signal$17  = \$signal$16 ;
  assign \$signal$19  = \$signal$18 ;
  assign o2 = { \$13 , \$12 , \$11 , \$10 , \$9 , \$8 , \$7 , \$6  };
  assign o = { \$13 , \$12 , \$11 , \$10 , \$9 , \$8 , \$7 , \$6  };
  assign \o$22  = { \$13 , \$12 , \$11 , \$10 , \$9 , \$8 , \$7 , \$6  };
  assign \port$66$0  = \$6 ;
  assign \port$67$0  = \$7 ;
  assign \port$68$0  = \$8 ;
  assign \port$69$0  = \$9 ;
  assign \port$70$0  = \$10 ;
  assign \port$71$0  = \$11 ;
  assign \port$72$0  = \$12 ;
  assign \port$73$0  = \$13 ;
endmodule


module AND2x2_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	and (Y, A, B);

endmodule

module XOR2x1_ASAP7_75t_R (Y, A, B);
	output Y;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (A__bar, A);
	and (int_fwire_0, A__bar, B);
	not (B__bar, B);
	and (int_fwire_1, A, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

endmodule

module INVx1_ASAP7_75t_R (Y, A);
	output Y;
	input A;

	// Function
	not (Y, A);

endmodule

module FAx1_ASAP7_75t_R (CON, SN, A, B, CI);
	output CON, SN;
	input A, B, CI;

	// Function
	wire A__bar, B__bar, CI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6;

	not (CI__bar, CI);
	not (B__bar, B);
	and (int_fwire_0, B__bar, CI__bar);
	not (A__bar, A);
	and (int_fwire_1, A__bar, CI__bar);
	and (int_fwire_2, A__bar, B__bar);
	or (CON, int_fwire_2, int_fwire_1, int_fwire_0);
	and (int_fwire_3, A__bar, B__bar, CI__bar);
	and (int_fwire_4, A__bar, B, CI);
	and (int_fwire_5, A, B__bar, CI);
	and (int_fwire_6, A, B, CI__bar);
	or (SN, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3);

endmodule

module HAxp5_ASAP7_75t_R (CON, SN, A, B);
	output CON, SN;
	input A, B;

	// Function
	wire A__bar, B__bar, int_fwire_0;
	wire int_fwire_1;

	not (B__bar, B);
	not (A__bar, A);
	or (CON, A__bar, B__bar);
	and (int_fwire_0, A__bar, B__bar);
	and (int_fwire_1, A, B);
	or (SN, int_fwire_1, int_fwire_0);

endmodule

module AO21x1_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2);
	or (Y, int_fwire_0, B);

endmodule

module AO22x1_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0);

endmodule

module AO33x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3);
	output Y;
	input A1, A2, A3, B1, B2, B3;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2, B3);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0);

endmodule
