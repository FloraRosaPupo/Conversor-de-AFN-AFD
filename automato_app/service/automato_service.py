# Importa as bibliotecas necessárias
from flask import Flask, request, jsonify
from flask_cors import CORS
import traceback

# Cria uma instância do Flask e permite CORS
app = Flask(__name__)
CORS(app)

class AFD:
    def __init__(self, estados, alfabeto, funcao_transicao, estado_inicial, estados_aceitacao):
        self.estados = estados  
        self.alfabeto = alfabeto 
        self.funcao_transicao = funcao_transicao   
        self.estado_inicial = estado_inicial    
        self.estados_aceitacao = estados_aceitacao    

    def simular(self, palavra):
        estado_atual = self.estado_inicial 
        for simbolo in palavra:
            estado_atual = self.funcao_transicao.get((estado_atual, simbolo), None)
            if estado_atual is None:
                return False 
        return estado_atual in self.estados_aceitacao  

class AFN:
    def __init__(self, estados, alfabeto, funcao_transicao, estado_inicial, estados_aceitacao):
        self.estados = estados 
        self.alfabeto = alfabeto  
        self.funcao_transicao = funcao_transicao   
        self.estado_inicial = estado_inicial    
        self.estados_aceitacao = estados_aceitacao    

    def simular(self, palavra):
        return self._simular_recursivo({self.estado_inicial}, palavra)

    def _simular_recursivo(self, estados_atuais, palavra):
        if not palavra:
            return bool(estados_atuais & self.estados_aceitacao)
        proximos_estados = set()
        for estado in estados_atuais:
            proximos_estados.update(self.funcao_transicao.get((estado, palavra[0]), set()))
        return self._simular_recursivo(proximos_estados, palavra[1:])

def afn_para_afd(afn):
    novos_estados = set()
    nova_funcao_transicao = {}
    novo_estado_inicial = frozenset([afn.estado_inicial])
    novos_estados_aceitacao = set()

    fila_estados = [novo_estado_inicial]
    while fila_estados:
        atual = fila_estados.pop(0)
        novos_estados.add(atual)
        if atual & afn.estados_aceitacao:
            novos_estados_aceitacao.add(atual)
        for simbolo in afn.alfabeto:
            proximo_estado = frozenset(
                estado for cs in atual for estado in afn.funcao_transicao.get((cs, simbolo), set())
            )
            nova_funcao_transicao[(atual, simbolo)] = proximo_estado
            if proximo_estado not in novos_estados:
                fila_estados.append(proximo_estado)

    return AFD(novos_estados, afn.alfabeto, nova_funcao_transicao, novo_estado_inicial, novos_estados_aceitacao)

def minimizar_afd(afd):
    # Algoritmo de minimização de AFD (a ser implementado)
    # Retorne o AFD minimizado
    return afd  # Placeholder; implementar minimização aqui

@app.route('/simular', methods=['POST'])
def simular():
    try:
        dados = request.json  # Obtém os dados da requisição
        tipo_automato = dados.get('tipo_automato')
        estados = dados.get('estados')
        alfabeto = dados.get('alfabeto')
        transicoes = dados.get('transicoes')
        estado_inicial = dados.get('estado_inicial')
        estados_aceitacao = dados.get('estados_aceitacao')
        palavras = dados.get('palavras')
        minimizar = dados.get('minimizar', False)  # Adiciona a opção de minimização

        estados = set(estados)
        alfabeto = set(alfabeto)
        funcao_transicao = {}
        for t in transicoes:
            if ',' in t:
                estado, simbolo, proximo_estado = t.split(',')
                funcao_transicao[(estado.strip(), simbolo.strip())] = proximo_estado.strip()
            else:
                return jsonify({"erro": f"Transição inválida: {t}"}), 400

        estados_aceitacao = set(estados_aceitacao)

        if tipo_automato == 'AFD':
            automato = AFD(estados, alfabeto, funcao_transicao, estado_inicial, estados_aceitacao)
            if minimizar:
                automato = minimizar_afd(automato)
        elif tipo_automato == 'AFN':
            automato = AFN(estados, alfabeto, funcao_transicao, estado_inicial, estados_aceitacao)
            automato = afn_para_afd(automato)
            if minimizar:
                automato = minimizar_afd(automato)
        else:
            return jsonify({"erro": "Tipo de autômato inválido. Use 'AFD' ou 'AFN'."}), 400

        resultados = {palavra: {'aceito': automato.simular(palavra)} for palavra in palavras}
        return jsonify(resultados)
    except Exception as e:
        traceback.print_exc()
        return jsonify({"erro": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
