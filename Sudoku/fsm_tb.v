module fsm_tb;

    reg clk = 0;
    reg reset = 1;
    reg up, right, down, left, x, y, z, v, r, o, start;
    wire wrong, lose, cel_count, win, can_access;

    // Instância da FSM
    fsm uut (
        .clk(clk), .reset(reset),
        .up(up), .right(right), .down(down), .left(left),
        .x(x), .y(y), .z(z), .v(v), .r(r), .o(o), .start(start),
        .wrong(wrong), .lose(lose), .cel_count(cel_count), .win(win), .can_access(can_access)
    );

    // Clock: alterna a cada 5ns (período = 10ns)
    always #5 clk = ~clk;

    initial begin
        // Inicializa tudo
        {up, right, down, left, x, y, z, v, r, o, start} = 0;
        #10 reset = 0;

        // ===============================
        // SEQUÊNCIA PARA PASSAR POR TODOS OS ESTADOS
        // ===============================

        // Q0 -> Q1 (via up)
        up = 1; #10; up = 0; #10;

        // Q1 -> Q2 (via x)
        x = 1; #10; x = 0; #10;

        // Q2 -> Q2 (movimentos): right -> down -> left
        right = 1; #10; right = 0; #10;
        down = 1;  #10; down = 0;  #10;
        left = 1;  #10; left = 0;  #10;

        // Acessa célula em Q2 (x)
        x = 1; #10; x = 0; #10;

        // Tentativa de erro: comando inválido (v, z, etc.)
        z = 1; #10; z = 0; #10;

        // Acessa célula com comando válido
        x = 1; #10; x = 0; #10;

        // Avança para vitória (última célula acessada)
        x = 1; #10; x = 0; #10;

        // Vitória ativada
        start = 0; #10;

        // Reinicia o jogo
        start = 1; #10; start = 0; #10;

        // Caminho alternativo até erro e perda
        up = 1; #10; up = 0; #10;
        x = 1; #10; x = 0; #10;
        down = 1; #10; down = 0; #10;
        x = 1; #10; x = 0; #10;
        y = 1; #10; y = 0; #10; // comando que pode gerar erro ou transição inválida
        x = 1; #10; x = 0; #10;

        // Finaliza simulação
        #50;
        $finish;
    end
endmodule