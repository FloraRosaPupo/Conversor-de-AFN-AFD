from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/simulate', methods=['POST'])
def simulate():
    try:
        data = request.get_json()

        estados = data.get('estados', [])
        alfabeto = data.get('alfabeto', [])
        transicao = data.get('transicao', [])
        estado_inicial = data.get('estado_inicial', '')
        fita = list(data.get('fita', ''))
        final_estados = data.get('final_estados', [])

        if not estados or not alfabeto or not transicao or not estado_inicial or not fita or not final_estados:
            return jsonify({'error': 'Todos os campos são obrigatórios'})

        current_state = estado_inicial
        head_position = 0
        transicoes_realizadas = []

        print(f"Estado inicial: {current_state}")
        print(f"Fita inicial: {''.join(fita)}")
        print(f"Posição da cabeça: {head_position}")

        while True:
            if head_position < 0:
                fita.insert(0, ' ')
                head_position = 0
            elif head_position >= len(fita):
                fita.append(' ')

            current_symbol = fita[head_position]
            transition_found = False

            # Processa cada transição
            for transition in transicao:
                parts = [part.strip() for part in transition.split(',')]
                
                if len(parts) != 5:
                    return jsonify({'error': f'Transição mal formatada: {transition}'})
                
                state, symbol, new_state, new_symbol, movement = parts

                if state == current_state and symbol == current_symbol:
                    fita[head_position] = new_symbol
                    transicoes_realizadas.append(f"{state},{symbol} -> {new_state},{new_symbol},{movement}")
                    current_state = new_state
                    head_position += 1 if movement == 'R' else -1
                    transition_found = True
                    break

            # Exibe o estado atual e a fita no terminal
            print(f"Estado atual: {current_state}")
            print(f"Fita atual: {''.join(fita)}")
            print(f"Posição da cabeça: {head_position}")
            print(f"Transições realizadas: {transicoes_realizadas}")

            if not transition_found:
                if current_state in final_estados:
                    break
                else:
                    return jsonify({'error': 'Nenhuma transição válida encontrada'})

        resultado = {
            'final_fita': ''.join(fita).strip(),
            'final_state': current_state,
            'transicoes': transicoes_realizadas,
        }

        print(f"Resultado final: {resultado}")

        return jsonify(resultado)
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
