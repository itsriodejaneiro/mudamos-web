# Mudamos

Mudamos é uma plataforma web desenvolvida com o framework Ruby on Rails.


### Setup do projeto para desenvolvimento

Caso seja necessário customizar variáveis de ambiente para o ambiente em questão, use o exemplo `.env.sample` para criar o arquivo de váriaveis de ambiente para desenvolvimento:

- `cp .env.sample .env.development`

Agora, customize-o de acordo com sua necessidade.

Caso os valores padrão do exemplo já sejam suficientes, não há necessidade de gerar o arquivo manualmente. O comando de `setup` fará isso por você.

- `bin/setup` -- instala dependências e prepara o banco de dados

Agora para acessar a área admin, crie um usuário:

- `rake users:create_admin_user`
