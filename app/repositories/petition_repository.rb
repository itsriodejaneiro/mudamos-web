class PetitionRepository
  include Repository

  def mock
    Petition.new body_mock, document_url_mock
  end

  private

  def document_url_mock
    "https://mudamos-its-production-images.s3.amazonaws.com/uploads/production/compilation_files/1/files/original.pdf"
  end

  def body_mock
    return <<-BODY.strip_heredoc
      # Projeto de Lei

      Altera a Lei nº 13.242, de 30 de dezembro de 2015,
      que dispõe sobre as diretrizes para a elaboração e a
      execução da Lei Orçamentária de 2016.

      **O CONGRESSO NACIONAL** decreta:

      Art. 1º A Lei nº 13.242, de 30 de dezembro de 2015, passa a vigorar com as seguintes
      alterações:

      Art. 2º A elaboração e a aprovação do *Projeto de Lei Orçamentária de 2016*, bem como a
      execução da respectiva Lei, deverão ser compatíveis com a obtenção da meta de superávit primário
      para o setor público consolidado não financeiro de R$ 9.310.000.000,00 (nove bilhões, trezentos e
      dez milhões de reais), sendo a meta de superávit primário dos Orçamentos Fiscal e da Seguridade
      Social de R$ 2.756.000.000,00 (dois bilhões, setecentos e cinquenta e seis milhões de reais), e R$
      0,00 (zero real) para o Programa de Dispêndios Globais, conforme demonstrado no Anexo de Metas
      Fiscais constante do Anexo IV a esta Lei.

      § 4º A meta de superávit primário prevista no **caput** e no § 2º poderá ser reduzida:
      I - dos montantes frustrados, até o limite de:

      a) R$ 40.256.000.000,00 (quarenta bilhões, duzentos e cinquenta e seis milhões de reais), das
      receitas administradas pela Secretaria da Receita Federal do Brasil; e

      b) R$ 41.700.000.000,00 (quarenta e um bilhões e setecentos milhões de reais), das receitas
      de concessões e permissões, dividendos e participações e operações com ativos;
      II - em até R$ 17.450.000.000,00 (dezessete bilhões, quatrocentos e cinquenta milhões de
      reais), relacionados ao pagamento de despesas, sendo:

      a) até R$ 12.500.000.000,00 (doze bilhões e quinhentos milhões de reais), relativos a
      investimentos do Programa de Aceleração do Crescimento - PAC, dos quais R$ 3.500.000.000,00
      (três bilhões e quinhentos milhões de reais) referentes a ações do Ministério da Defesa;

      b) até R$ 3.000.000.000,00 (três bilhões de reais), referentes a ações de vigilância sanitária,
      combate a endemias e reforço do Sistema Único de Saúde - SUS, no âmbito do Ministério da
      Saúde; e

      c) até R$ 1.950.000.000,00 (um bilhão, novecentos e cinquenta milhões de reais), referentes
      ao pagamento do auxílio financeiro aos Estados, ao Distrito Federal e aos Municípios para fomento das exportações; e

      III - do valor equivalente à frustração da meta prevista no § 2º, desde que em decorrência dos
      processos de reestruturação e alongamento de dívidas dos Estados e do Distrito Federal junto à
      União, no âmbito da Lei nº 9.496, de 11 de setembro de 1997, e de renegociação dos contratos entre os Estados e o Distrito Federal e as instituições públicas federais, com recursos do Banco Nacional de Desenvolvimento Econômico e Social - BNDES.” (NR)

      #### Art. 99.

      > § 14. Não se aplica o prazo previsto no § 2º para as proposições referentes aos seguintes
      cargos e carreiras:

      I - cargos de Perito Médico Previdenciário e Supervisor Médico-Pericial do Instituto Nacional
      do Seguro Social - INSS, de que trata a Lei nº 11.907, de 2 de fevereiro de 2009;

      II - cargos de Analista de Infraestrutura, da Carreira de Analista de Infraestrutura, e cargo
      isolado de Especialista em Infraestrutura Sênior, de que trata a Lei nº 11.539, de 8 de novembro de 2007;

      III - cargos de Analista Técnico de Políticas Sociais, de que trata a Lei nº 12.094, de 19 de
      novembro de 2009;

      IV - cargos das Carreiras e do Plano Especial de Cargos do Departamento Nacional de Infraestrutura de Transportes - DNIT, de que trata a Lei nº 11.171, de 2 de setembro de 2005;

      V - cargos da Carreira de Perito Federal Agrário, de que trata a Lei nº 10.550, de 13 de
      novembro de 2002;

      VI - cargos de Delegado de Polícia Federal, Perito Criminal Federal, Escrivão de Polícia
      Federal, Agente de Polícia Federal e Papiloscopista Policial Federal, de que trata o Decreto-Lei nº
      2.251, de 26 de fevereiro de 1985;
      VII - cargos da Carreira de Policial Rodoviário Federal, de que trata a Lei nº 9.654, de 2 de
      junho de 1998;
      VIII - cargos de Auditor-Fiscal da Receita Federal do Brasil e Analista-Tributário da Receita
      Federal do Brasil, da Carreira de Auditoria da Receita Federal do Brasil, de que trata a Lei nº
      10.593, de 6 de dezembro de 2002;

      IX - cargos da Carreira de Diplomata, da Carreira de Oficial de Chancelaria e da Carreira de
      Assistente de Chancelaria, de que trata a Lei nº 11.440, 29 de dezembro de 2006;

      X - cargos de:

      a) Médico, Médico de Saúde Pública, Médico do Trabalho, Médico Marítimo e Médico
      Veterinário do Plano Geral de Cargos do Poder Executivo - PGPE, de que trata a Lei nº 11.357, 19
      de outubro de 2006;

      b) Médico do Quadro de Pessoal da Advocacia-Geral da União, de que trata a Lei nº 10.480,
      de 2 de julho de 2005;

      c) Médico do Quadro de Pessoal da Fundação Nacional do Índio - FUNAI, de que trata a Lei
      nº 11.907, de 2009;

      d) Médico, Médico de Saúde Pública, Médico Cirurgião, Médico do Trabalho e Médico
      Veterinário da Carreira da Previdência, da Saúde e do Trabalho, de que trata a Lei nº 11.355, de
      2006;

      e) Médico do Plano Especial de Cargos do Ministério da Fazenda - PECFAZ, de que trata a
      Lei nº 11.907, de 2010;

      f) Médico-Profissional Técnico Superior da Cultura, de que trata a Lei nº 11.233, de 22 de
      dezembro de 2005;

      g) Médico do Plano Especial de Cargos do Departamento de Polícia Rodoviária Federal, de
      que trata Lei nº 11.095, de 13 de janeiro de 2005;

      h) Médico do Plano Especial de Cargos do Departamento de Polícia Federal, de que trata a
      Lei nº 10.682, de 28 de maio de 2003;

      i) Médico do Plano de Carreira dos Cargos de Reforma e Desenvolvimento Agrário, de que
      trata a Lei nº 11.090, de 7 de janeiro de 2005;

      j) Médico da Carreira da Seguridade Social e do Trabalho dos Quadros de Pessoal do
      Ministérios da Saúde, do Ministério da Previdência Social, do Ministério do Trabalho e Emprego e
      da Fundação Nacional da Saúde - FUNASA, de que trata a Lei nº 10.483, de 3 de julho de 2002;

      k) Médico do Quadro de Pessoal do INSS, de que trata a Lei nº 10.355, de 26 de dezembro de
      2001;

      l) Médico, de que trata a Lei nº 5.645, de 10 de dezembro de 1970; e
      m) Médico do Quadro de Pessoal da Imprensa Nacional, de que trata a Lei nº 11.090, de
      2005; e XI - cargos de Auditor-Fiscal do Trabalho, da Carreira de Auditoria-Fiscal do Trabalho, de
      que trata a Lei nº 10.593, de 6 de dezembro de 2002.” (NR)
    BODY
  end
end
