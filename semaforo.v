module semaforo(
	input clock, 
	input reset,
	input botao,
	output reg [1:0]estado //pra que exatamente serve esse output?
	);

reg [14:0]count;
reg flag;
reg [1:0]next, actual;
/*
obs.: na solucao da monitoria utilizaram '<=' para
atribuiçao, quando no slide diz que esse operador eh pra
comparacao. afinal, pra que ele serve?
*/
parameter preVerde = 0;
parameter verde = 1;
parameter preAmarelo = 2;
parameter amarelo = 3;
parameter preVermelho = 4;
parameter vermelho = 5;
parameter bot = 6;

parameter dez_mil = 14'd10000;
parameter quin = 14'd500;
//initial eh executado no inicio apenas uma vez
//define os parametros iniciais do programa
initial begin
	actual = preVerde;
	count = dez_mil;
	flag = 1'b1;
	next = verde;
end

//sequencial
//envolve as operaçoes que serao necessarias
//ao longo do tempo (sao como funçoes)
always @(posedge clock or posedge reset) begin
	if (reset) begin
		actual = preVerde;
	end
	else begin
		actual = verde;
		case(actual)
			verde: begin
				$display ("Sinal verde");
				estado = 2'b00;
				count = count-1;
			end
			bot: begin
				$display ("botao pressionado!");
				count = count << 1;
				flag = 0;
			end
			preAmarelo: begin
				$display ("INDO PARA AMARELO");
				count = quin;
			end 
			amarelo: begin
				$display ("Sinal amarelo");
				count = count-1;
				estado = 2'b01;
			end
			preVermelho: begin
				$display ("Indo para vermelho");
				count = dez_mil;
			end
			vermelho: begin
				$display ("Sinal vermelho");
				count = count-1;
				estado = 2'b10;
			end
			preVerde: begin
				$display ("Indo para verde!");
				count = dez_mil;
				flag = 1;
			end
		endcase
	end
end

//combinacional para todo tempo verificar algo
//aqui vem o programa em si (main)
always @(*) begin
	//duvida: nao deveria ter algum caso de reset aqui? pq?
	case(actual)
		verde: begin
			if(botao && flag) next = bot;
			else if(count == 0) next = preAmarelo;
			else next = verde;
		end
		bot: begin
			next = verde;
		end
		preAmarelo: begin
			next = amarelo;
		end
		amarelo: begin
			if(count == 0) next = preVermelho;
			else next = amarelo;
		end
		preAmarelo: begin
			next = vermelho;
		end
		vermelho: begin
			if(count == 0) next = preVerde;
			else next = vermelho;
		end
	endcase
	actual = next; //essa atribuicao nao tava na solucao
	//altero o estado atual para o proximo nela. faz sentido?
end


endmodule

//duvida final: qual a melhor forma de testar esse programa
//sem usar quartus? (programei pelo sublime e tenho o iverilog instalado)
//como debugar? como simular? (o que tu recomenda?)