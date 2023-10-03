Preparando o TheHive

Criamos uma nova organização na interface web do TheHive com uma conta de administrador.

![Logo do GitHub](https://github.com/zeroproj/MHSoc/blob/main/MHDoc/MHIMG/01.png?raw=true)

Interface web do TheHive
Na organização de teste, criamos um novo usuário com privilégios de administrador da organização.

Organização de Teste do TheHive
Esse usuário tem permissões para gerenciar a organização, incluindo a criação de novos usuários, o gerenciamento de casos e alertas, entre outras funções. Também criamos uma senha para esse usuário, para que possamos fazer login, visualizar o painel e gerenciar casos. Isso é feito clicando em "Nova senha" ao lado da conta do usuário e inserindo a senha desejada.

Clique em "Nova senha" ao lado da conta do usuário e insira a senha desejada
A integração com o Wazuh é possível com a ajuda da API REST do TheHive. Portanto, precisamos de um usuário no TheHive que possa criar alertas por meio da API. Criamos uma conta com privilégio de "analista" para esse fim.

Criamos uma conta com o privilégio de "analista" para esse fim
Para a próxima etapa, geramos a chave da API para o usuário:

Para a próxima etapa, geramos a chave da API para o usuário
Para extrair a chave da API, revelamos a chave para visualizá-la e copiá-la para uso futuro:

Revelamos a chave para visualizá-la e copiá-la para uso futuro