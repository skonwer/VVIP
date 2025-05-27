// Code your testbench here
// or browse Examples
module test;
  
  reg [3:0] a,b;
  wire [7:0] c;
  
  
  abc dut (
    .a(a),
    .b(b),
    .out(c)
  );
  
  
  
  initial begin
    $monitor("a = %b  b = %b. c = %b", &a, &b,&c );
	a=0;b=0;
    #5 a=4'b1001; b=4'b0010;
    #5 a=4'b1111; b=4'b0010;
    #5 $finish;
  end


  endmodule


  module abc (
  input [3:0]a, 
  input [3:0]b,
  output signed [7:0] out
  
);
  assign out = $signed({a[3],a}) * $signed({b[3],b});
  
  
endmodule
