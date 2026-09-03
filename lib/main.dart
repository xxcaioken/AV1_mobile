import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TelaAtivacaoCartao(),
  ));
}

class TelaAtivacaoCartao extends StatefulWidget {
  const TelaAtivacaoCartao({super.key});

  @override
  State<TelaAtivacaoCartao> createState() => _TelaAtivacaoCartaoState();
}

class _TelaAtivacaoCartaoState extends State<TelaAtivacaoCartao> {
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _limiteController =
      TextEditingController(text: '500');

  bool _cartaoAtivo = false;
  bool _cvvOculto = true;
  String _moedaSelecionada = 'USD';
  String _mensagemErro = '';
  bool _mostrarSucesso = false;

  static const Color _corFundo = Color(0xFFF1F5F9);
  static const Color _corEscura = Color(0xFF111C33);
  static const Color _corDestaque = Color(0xFFEF4444);
  static const Color _corSucesso = Color(0xFF16A34A);
  static const Color _corRotulo = Color(0xFF64748B);
  static const Color _corBorda = Color(0xFFCBD5E1);

  @override
  void dispose() {
    _cvvController.dispose();
    _limiteController.dispose();
    super.dispose();
  }

  void _incrementarLimite() {
    setState(() {
      final int limiteAtual = int.tryParse(_limiteController.text.trim()) ?? 0;
      _limiteController.text = '${limiteAtual + 100}';
    });
  }

  void _alternarVisibilidadeCvv() {
    setState(() {
      _cvvOculto = !_cvvOculto;
    });
  }

  void _selecionarMoeda(String moeda) {
    setState(() {
      _moedaSelecionada = moeda;
    });
  }

  void _confirmarAtivacao() {
    final String cvv = _cvvController.text.trim();
    final int limite = int.tryParse(_limiteController.text.trim()) ?? 0;

    setState(() {
      if (cvv.length < 3) {
        _mensagemErro = 'O CVV deve conter no mínimo 3 dígitos.';
        _mostrarSucesso = false;
        _cartaoAtivo = false;
      } else if (limite < 100) {
        _mensagemErro = 'O limite diário não pode ser menor que R\$ 100.';
        _mostrarSucesso = false;
        _cartaoAtivo = false;
      } else {
        _mensagemErro = '';
        _mostrarSucesso = true;
        _cartaoAtivo = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 24),
                  child: Text(
                    'Ativação de Cartão',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _corEscura,
                    ),
                  ),
                ),
              ),
              _construirCartao(),
              const SizedBox(height: 24),
              _construirRotulo('CÓDIGO DE SEGURANÇA (CVV)'),
              const SizedBox(height: 8),
              _construirCampoCvv(),
              const SizedBox(height: 20),
              _construirRotulo('SELEÇÃO DE DESTINO (MOEDA)'),
              const SizedBox(height: 8),
              _construirSeletorDeMoedas(),
              const SizedBox(height: 20),
              _construirRotulo('DEFINIR LIMITE DIÁRIO (R\$)'),
              const SizedBox(height: 8),
              _construirCampoLimite(),
              const SizedBox(height: 24),
              _construirBotaoConfirmar(),
              if (_mensagemErro.isNotEmpty) _construirMensagemErro(),
              if (_mostrarSucesso) _construirPainelSucesso(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCartao() {
    return Container(
      width: double.infinity,
      height: 170,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _corEscura,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 130),
                child: Text(
                  'BANCO GLOBAL',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.amber, size: 28),
                    SizedBox(width: 12),
                    Text(
                      '****  ****  ****',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '8842',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _construirEtiquetaStatus(),
          ),
        ],
      ),
    );
  }

  Widget _construirEtiquetaStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _cartaoAtivo ? _corSucesso : _corDestaque,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _cartaoAtivo ? Icons.verified_user : Icons.lock,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            _cartaoAtivo ? 'ATIVO' : 'BLOQUEADO',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirRotulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: _corRotulo,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _construirCampoCvv() {
    return TextField(
      controller: _cvvController,
      keyboardType: TextInputType.number,
      obscureText: _cvvOculto,
      maxLength: 4,
      style: const TextStyle(fontSize: 18, letterSpacing: 2),
      decoration: InputDecoration(
        counterText: '',
        hintText: 'Digite o CVV',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _corBorda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _corBorda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _corEscura, width: 2),
        ),
        suffixIcon: IconButton(
          onPressed: _alternarVisibilidadeCvv,
          icon: Icon(
            _cvvOculto ? Icons.visibility : Icons.visibility_off,
            color: _corEscura,
          ),
        ),
      ),
    );
  }

  Widget _construirSeletorDeMoedas() {
    return Row(
      children: [
        Expanded(child: _construirBotaoMoeda('USD', 'USD (\$)')),
        const SizedBox(width: 10),
        Expanded(child: _construirBotaoMoeda('EUR', 'EUR (€)')),
        const SizedBox(width: 10),
        Expanded(child: _construirBotaoMoeda('GBP', 'GBP (£)')),
      ],
    );
  }

  Widget _construirBotaoMoeda(String moeda, String texto) {
    final bool selecionada = _moedaSelecionada == moeda;

    return GestureDetector(
      onTap: () => _selecionarMoeda(moeda),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selecionada ? _corDestaque : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionada ? _corDestaque : _corBorda,
            width: selecionada ? 2 : 1,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: selecionada ? Colors.white : _corEscura,
            fontWeight: selecionada ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _construirCampoLimite() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _limiteController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: '0',
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _corBorda),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _corBorda),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _corEscura, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _incrementarLimite,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '+ R\$ 100',
              style: TextStyle(
                color: _corEscura,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _construirBotaoConfirmar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _confirmarAtivacao,
        icon: const Icon(Icons.lock, color: Colors.amber),
        label: const Text(
          'Confirmar e Ativar Cartão',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _corEscura,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _construirMensagemErro() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _corDestaque),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: _corDestaque),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _mensagemErro,
              style: const TextStyle(
                color: _corDestaque,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirPainelSucesso() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _corSucesso),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, color: _corSucesso, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cartão configurado com sucesso!',
                  style: TextStyle(
                    color: _corSucesso,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Destino $_moedaSelecionada com limite de '
                  'R\$ ${_limiteController.text.trim()}/dia.',
                  style: const TextStyle(color: _corSucesso, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
