module semaforo(
input clock,
input reset,
input botao,
output reg[1:0] estado);


reg flag;
reg [2:0] fsm, next;
reg [14:0]count;


parameter preVerde = 0;
parameter verde = 1;
parameter bot = 2;
parameter preAmarelo = 3;
parameter amarelo = 4;
parameter preVermelho = 5;
parameter vermelho = 6;

initial begin
	fsm = preVerde; //verde
	//next = preVerde; //verde
	//count = 10;
	//flag = 1'b0;
end



always@(posedge clock or posedge reset) begin
	if(reset) begin
		fsm <= preVerde;
	end
	else begin
		fsm <= next;
		case(fsm)
			verde: begin
				count <= count-1;
				estado <= 00;
			end
			bot: begin
				count[14:0] <= {1'b0, count[14:1]};
				flag <= 0;
				end
			preAmarelo: count <= 5;
			amarelo: begin
				estado <= 01;
				count <= count-1;
				end
			preVermelho: count <= 10;
			vermelho: begin
				estado <= 10;
				count <= count-1;
				end
			preVerde: begin
				count <= 10;	
				flag <= 1;
			  end	  		  
		endcase
	end
end
always@(*)begin
	case(fsm)
		verde: begin
			if(botao && flag) next <= bot;
			else if(count == 0) next <= preAmarelo;
			else next <= verde;
		end
		bot: begin 
			next <= verde;
		end
		preAmarelo: begin
			next <= amarelo;
		end
		amarelo: begin
				if(count==0) next <= preVermelho;
				else next <= amarelo;
		end
		preVermelho: begin
			next <= vermelho;
		end
		vermelho: begin
			if(count==0) next <= preVerde;
			else next <= vermelho;
		end
		preVerde: begin
			next <= verde;		  
		end
		default: begin
			next <= preVerde;
		end
	endcase
end


endmodule



