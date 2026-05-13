package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func JSONResponse(w http.ResponseWriter, statusCode int, success bool, message string, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)

	// Cria a estrutura padrão
	resp := DefaultResponse{
		Sucesso:  success,
		Mensagem: message,
		Data:     data,
	}

	if err := json.NewEncoder(w).Encode(resp); err != nil {
		log.Printf("Erro ao codificar resposta JSON: %v", err)
	}
}

func StrZero(pValor any, pLen int, pDec int) string {
	if pDec > 0 {
		// Formata com o ponto decimal e a precisão solicitada
		// O formato %0*.*f aplica: [tamanho total].[decimais]
		return fmt.Sprintf("%0*.*f", pLen, pDec, convertToFloat(pValor))
	}

	// Formata como inteiro, sem ponto decimal
	return fmt.Sprintf("%0*d", pLen, int64(convertToFloat(pValor)))
}

// Auxiliar para converter interface{} para float64
func convertToFloat(v any) float64 {
	switch t := v.(type) {
	case int:
		return float64(t)
	case int64:
		return float64(t)
	case float64:
		return t
	case float32:
		return float64(t)
	default:
		return 0
	}
}

func ler(dir string) ([]byte, error) {
	_, err := os.Stat(dir)

	if err == nil {
		// Caso 1: Arquivo existe e está tudo ok
		fmt.Println("Arquivo existe!")
	} else if os.IsPermission(err) {
		// Caso 3: Problema de permissão específico
		fmt.Println("Arquivo sem permissão, tentando alterar...")
		if err := os.Chmod(dir, 0664); err != nil {
			return nil, fmt.Errorf("falha ao alterar permissão: %w", err)
		}
	} else {
		// Caso 4: Outro erro desconhecido (ex: erro de hardware)
		return nil, fmt.Errorf("erro desconhecido ao acessar arquivo: %w", err)
	}

	// Agora que garantimos que o arquivo existe ou foi corrigido:
	return os.ReadFile(dir)
}

func gravar(diretorio string, nomeArq string, data []byte) error {

	err := os.MkdirAll(diretorio, 0755)
	if err != nil {
		return fmt.Errorf("erro ao criar diretório: %w", err)
	}
	dirCompleto := diretorio + nomeArq
	anexo, err := os.Create(dirCompleto)
	if err != nil {
		return fmt.Errorf("erro ao criar arquivo: %w", err)
	}
	defer anexo.Close()
	tamanho, err := io.Copy(anexo, bytes.NewReader(data))
	fmt.Printf("Arquivo gravado com %d bytes\n", tamanho)

	if err != nil {
		return err
	}
	return nil
}

func excluir(diretorio string) error {
	err := os.Remove(diretorio)
	if err != nil {
		return err
	}
	return nil
}

// Funcao que retorna uma lista das solicitações do usuario/ctr informado
func obtemListaSolicitacoes(dir string, usuario string) ([]string, error) {
	dirCompleto := dir + "solicUsers.json"
	var lista map[string][]string
	listaJson, erro := ler(dirCompleto)
	if erro != nil {
		return nil, erro
	}
	if err := json.Unmarshal(listaJson, &lista); err != nil {
		return nil, err
	}

	return lista[usuario], nil
}

// func gravarJson(diretorio string, data []byte, nomeData string, w http.ResponseWriter) error {
// 	err := os.MkdirAll(diretorio, 0755)
// 	if err != nil {
// 		http.Error(w, "Erro ao criar diretório: "+err.Error(), http.StatusInternalServerError)
// 		log.Printf("ERRO: Falha ao criar diretório %s: %v", diretorio, err)
// 		return err
// 	}

// 	diretorioJson := diretorio + nomeData
// 	err = os.WriteFile(diretorioJson, data, 0644)
// 	if err != nil {
// 		http.Error(w, "Erro ao salvar o arquivo JSON: "+err.Error(), http.StatusInternalServerError)
// 		log.Printf("ERRO: Falha ao salvar %s: %v", diretorioJson, err)
// 		return err
// 	}

// 	return nil
// }

// // limparArquivosAntigos varre o diretório e remove arquivos cujo nome começa com o prefixo.
// func limparArquivosAntigos(diretorio string, prefixo string) error {

// 	// 1. Lê o conteúdo do diretório
// 	files, err := os.ReadDir(diretorio)
// 	if err != nil {
// 		// Se o diretório não existir, não há o que limpar, apenas retorna.
// 		if os.IsNotExist(err) {
// 			return nil
// 		}
// 		log.Printf("ERRO: Falha ao ler diretório %s: %v", diretorio, err)
// 		return err
// 	}

// 	// 2. Itera sobre os arquivos
// 	for _, file := range files {
// 		nome := file.Name()

// 		// 3. Verifica se o nome do arquivo começa com o prefixo da solicitação
// 		if len(nome) >= len(prefixo) && nome[:len(prefixo)] == prefixo {
// 			caminhoCompleto := diretorio + nome
// 			fmt.Println("Removendo arquivo antigo:", caminhoCompleto)
// 			// 4. Remove o arquivo
// 			err := os.Remove(caminhoCompleto)
// 			if err != nil {
// 				log.Printf("AVISO: Falha ao remover o arquivo %s: %v", caminhoCompleto, err)
// 				// Continua a limpeza, não retorna o erro fatal aqui.
// 			} else {
// 				log.Printf("Arquivo antigo removido: %s", caminhoCompleto)
// 			}
// 		}
// 	}

// 	return nil
// }
