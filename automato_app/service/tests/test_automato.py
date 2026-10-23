import unittest
from automato_service import app
class AutomatoTests(unittest.TestCase):
    def setUp(self):self.client=app.test_client()
    def test_afn_preserva_destinos_com_nomes_multicaractere(self):
        response=self.client.post('/simular',json={'tipo_automato':'AFN','estados':['q0','q1','q2'],
          'alfabeto':['a','b'],'transicoes':['q0,a,q0','q0,a,q1','q1,b,q2'],
          'estado_inicial':'q0','estados_aceitacao':['q2'],'palavras':['ab','aab','a','']})
        self.assertEqual(response.status_code,200)
        self.assertEqual(response.json,{'ab':{'aceito':True},'aab':{'aceito':True},'a':{'aceito':False},'':{'aceito':False}})
    def test_json_invalido(self):
        self.assertEqual(self.client.post('/simular',json=[]).status_code,400)
    def test_campos_ausentes(self):
        self.assertEqual(self.client.post('/simular',json={}).status_code,400)
if __name__=='__main__':unittest.main()
