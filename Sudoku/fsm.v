module fsm (
    input clk,
    input reset,
    input up, right, down, left,
    input x, y, z, v, r, o, start,
    output reg wrong, lose, cel_count, win, can_access
);

    // Estados codificados manualmente
    parameter Q0 = 3'b000,
              Q1 = 3'b001,
              Q2 = 3'b010,
              Q3 = 3'b011,
              Q4 = 3'b100,
              Q5 = 3'b101;

    reg [2:0] state, next_state;

    // Lógica de transição de estado
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= Q0;
        else
            state <= next_state;
    end

    // Lógica combinacional de transição
    always @(*) begin
        next_state = state;

        case (state)
            Q0: begin
                if (up | right | down | left | x | y | z | v | r | o)
                    next_state = Q1;
            end
            Q1: begin
                if (x) next_state = Q2;
            end
            Q2: begin
                if (up | right | down | left)
                    next_state = Q2;
                else if (x)
                    next_state = Q3;
            end
            Q3: begin
                if (o) next_state = Q3;
                else if (x) next_state = Q2;
                else if (x & ~start) next_state = Q4;
                else if (x & start) next_state = Q5;
            end
            Q4: begin
                next_state = Q0;
            end
            Q5: begin
                next_state = Q0;
            end
        endcase

        if (start)
            next_state = Q0;
    end

    // Lógica de saída
    always @(*) begin
        wrong = 0;
        lose = 0;
        cel_count = 0;
        win = 0;
        can_access = 0;

        case (state)
            Q3: if (x & ~start) begin
                    cel_count = 1;
                    win = 1;
                end else if (x & start) begin
                    wrong = 1;
                    lose = 1;
                end else if (x) begin
                    cel_count = 1;
                end
            Q4: begin
                win = 1;
                cel_count = 1;
            end
            Q5: begin
                wrong = 1;
                lose = 1;
            end
            Q2: if (x) begin
                can_access = 1;
            end
        endcase
    end
endmodule

