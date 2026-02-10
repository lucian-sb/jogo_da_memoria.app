# Guia de Contribuicao

## Mensagens de Commit

Para evitar problemas de encoding no Git, use apenas caracteres ASCII nas mensagens de commit.

### Exemplos Corretos

```
Initial commit: Jogo da Memoria - Flutter app infantil
Fix: Corrigir layout em telas pequenas
Add: Sistema de ranking local
Update: Melhorar performance do jogo
```

### Exemplos Incorretos

```
Jogo da Memória – versão inicial
Corrigir layout em telas pequenas
Adicionar sistema de ranking
```

## Encoding de Arquivos

- Todos os arquivos de documentacao (.md) devem estar em UTF-8 sem BOM
- Codigo fonte pode usar UTF-8 normalmente
- Evite caracteres especiais em nomes de arquivos

## Estrutura de Commits

Use o formato:
```
[Tipo]: [Descricao curta]

[Tipo] pode ser:
- Initial: Commit inicial
- Add: Adicionar nova funcionalidade
- Fix: Corrigir bug
- Update: Atualizar funcionalidade existente
- Refactor: Refatorar codigo
- Docs: Atualizar documentacao
```
