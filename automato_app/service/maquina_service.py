from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/simulate', methods=['POST'])
def simulate():
    data = request.get_json()

    print("Dados recebidos:", data)

    estados = data.get('estados', [])
    alfabeto = data.get('alfabeto', [])
    transicao = data.get('transicao', [])
    estado_inicial = data.get('estado_inicial', '')
    fita = list(data.get('fita', ''))
    final_estados = data.get('final_estados', [])

    print("Estados:", estados)
    print("Alfabeto:", alfabeto)
    print("Transição:", transicao)
    print("Estado inicial:", estado_inicial)
    print("Fita inicial:", fita)
    print("Estados finais:", final_estados)

    if not estado_inicial or not fita or not final_estados or not transicao:
        return jsonify({'error': 'Dados incompletos'})

    estado_atual = estado_inicial
    cabeca_posicao = 0
    transicao_realizada = []  

    while estado_atual not in final_estados:
        if cabeca_posicao < 0 or cabeca_posicao >= len(fita):
            return jsonify({'error': 'Cabeça fora dos limites da fita'})

        simbolo_atual = fita[cabeca_posicao]
        transicao_encontrada = False

        for transition in transicao:
            try:
                estado, simbolo,novo_estados, novo_simbolo, movimento = transition.split(',')
                if estado == estado_atual and simbolo == simbolo_atual:
                    fita[cabeca_posicao] = novo_simbolo
                    transicao_realizada.append(f"{estado},{simbolo} -> {novo_estados},{novo_simbolo},{movimento}")
                    estado_atual =novo_estados
                    cabeca_posicao += 1 if movimento == 'R' else -1
                    transicao_encontrada = True
                    break
            except ValueError as e:
                return jsonify({'error': f'Erro ao processar transição: {transition} - {e}'})

        if not transicao_encontrada:
            return jsonify({'error': 'Nenhuma transição válida encontrada'})

    return jsonify({
        'final_fita': ''.join(fita),
        'final_estado': estado_atual,
        'transicoes': transicao_realizada
    })

if __name__ == '__main__':
    app.run(debug=True)
