module blackbox(s, k, d, e);
    output s;
    input  k, d, e;
    wire   w03, w08, w19, w25, w35, w40, w41, w44, w47, w59, w66, w71, w78, w81, w90, w91, w94;

    or  o67(s, w90, w25, w35);
    and a20(w25, w91, w44);
    not n96(w44, w91);
    and a45(w35, w19, w94);
    not n53(w19, w94);
    and a56(w91, w78, w41);
    not n26(w78, d);
    or  o79(w41, k, w03);
    not n6(w03, e);
    or  o22(w94, w66, w81);
    and a39(w66, k, w59);
    not n86(w59, d);
    and a97(w81, w47, w40, w71);
    not n57(w47, e);
    not n55(w40, d);
    not n61(w71, k);
    or  o77(w90, e, k, w08);
    not n9(w08, d);

endmodule // blackbox
