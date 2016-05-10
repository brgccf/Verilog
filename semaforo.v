module semaforo(
	input clock, 
	input reset,
	input botao,
	output reg [1:0]estado //pra que exatamente serve esse output?
	                       //Supondo que esse módulo controle um semaforo
						   //é essa saida que diria qual cor deveria acender
	);

reg [14:0]count;
reg flag;
reg [1:0]next, actual;
/*
obs.: na solucao da monitoria utilizaram '<=' para
atribuiçao, quando no slide diz que esse operador eh pra
comparacao. afinal, pra que ele serve?
--Pressa na hora de fazer os slides esqueci que vcs não fazem testbench, mas dentro de um bloco initial
 para verificação <= é um operador lógico
-- <= é uma atribuição não bloqueante, ou seja todas são feitas em paralelo
 dentro de um bloco, normalmente usamos ela em blocos sequenciais
-- e a atribuição bloqueante '=' é usado em circuito combinacional
-- 
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
//e pode também conter o código do testbench,que pode manipular o valor das coisas :)
initial begin
	actual = preVerde;
	count = dez_mil;
	flag = 1'b1;
	next = verde;
end

//sequencial
//envolve as operaçoes que serao necessarias
//ao longo do tempo (sao como funçoes)
//também pode ser visto como o carinha que sincroniza os estados e ajusta as saidas de acordo com o estado
always @(posedge clock or posedge reset) begin
	if (reset) begin
		actual = preVerde;
	end
	else begin
		actual = next;
	end
	else begin
		actual = verde; // vc esta deixando ele verde o tempo todo
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
//também conhecida como a grandiosa mudança de estados kkk
always @(*) begin
	//duvida: nao deveria ter algum caso de reset aqui? pq?
	//vc só pode atribuir em uma variavel dentro de um bloco, visto que todos estao executando em paralelo
	//então, o reset fica no bloco sequencial pq ele vai modificar o estado atual
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
	
end


endmodule

//duvida final: qual a melhor forma de testar esse programa
//sem usar quartus? (programei pelo sublime e tenho o iverilog instalado)
//como debugar? como simular? (o que tu recomenda?)
/*
	Não usar o quartus pra programar já é uma coisa boa kkkkk
	ele é uma ferramente de sintese, e na versão 9.2 tem uma ferramenta de verificação(waveform) que é muito útil.
	a melhor forma de debugar mesmo seria usando uma ferramenta de verificação, como o modelsim, por exemplo
	porém vc teria que ver um pouco de testbench pra fazer isso da melhor forma, ou usar o waveform do modelsim kkkkk
	
	
*/