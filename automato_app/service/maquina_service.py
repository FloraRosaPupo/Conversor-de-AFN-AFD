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
        transicao_realizada = []

        print(f"Estado Inicial: {current_state}")
        print(f"Fita Inicial: {''.join(fita)}")

        while True:
            if head_position < 0 or head_position >= len(fita):
                # Expande a fita com espaço em branco se a cabeça sair dos limites
                if head_position < 0:
                    fita.insert(0, ' ')
                    head_position = 0
                else:
                    fita.append(' ')

            current_symbol = fita[head_position]
            transition_found = False

            print(f"\nEstado Atual: {current_state}")
            print(f"Posição da Cabeça: {head_position}")
            print(f"Símbolo Atual: {current_symbol}")
            print(f"Fita Atual: {''.join(fita)}")

            # Processa cada transição
            for transition in transicao:
                parts = [part.strip() for part in transition.split(',')]
                
                if len(parts) != 5:
                    return jsonify({'error': f'Transição mal formatada: {transition}'})
                
                state, symbol, new_state, new_symbol, movement = parts

                print(f"Tentando Transição: {transition}")

                if state == current_state and symbol == current_symbol:
                    fita[head_position] = new_symbol
                    transicao_realizada.append(f"{state},{symbol} -> {new_state},{new_symbol},{movement}")
                    current_state = new_state
                    head_position += 1 if movement == 'R' else -1
                    transition_found = True
                    print(f"Transição Aplicada: {transicao_realizada[-1]}")
                    print(f"Fita Atualizada: {''.join(fita)}")
                    break

            if not transition_found:
                if current_state in final_estados:
                    print(f"\nEstado Final: {current_state}")
                    print(f"Fita Final: {''.join(fita)}")
                    break
                else:
                    return jsonify({'error': 'Nenhuma transição válida encontrada'})

        return jsonify({
            'final_fita': ''.join(fita).strip(),
            'final_state': current_state,
            'transicoes': transicao_realizada
        })
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
