from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/simular', methods=['POST'])
def simular():
    dados = request.get_json()

    estados = dados['states']
    alfabeto = dados['alphabet']
    transicoes = dados['transitions']
    estado_inicial = dados['initial_state']
    fita = list(dados['tape'])
    estados_finais = dados['final_states']

    estado_atual = estado_inicial
    posicao_cabeca = 0

    while estado_atual not in estados_finais:
        if posicao_cabeca < 0 or posicao_cabeca >= len(fita):
            return jsonify({'erro': 'Cabeçote fora dos limites da fita'})

        simbolo_atual = fita[posicao_cabeca]
        transicao_encontrada = False

        for transicao in transicoes:
            estado, simbolo, novo_estado, novo_simbolo, movimento = transicao.split(',')
            if estado == estado_atual and simbolo == simbolo_atual:
                fita[posicao_cabeca] = novo_simbolo
                estado_atual = novo_estado
                posicao_cabeca += 1 if movimento == 'R' else -1
                transicao_encontrada = True
                break

        if not transicao_encontrada:
            return jsonify({'erro': 'Nenhuma transição válida encontrada'})

    return jsonify({'fita_final': ''.join(fita), 'estado_final': estado_atual})

if __name__ == '__main__':
    app.run(debug=True)
