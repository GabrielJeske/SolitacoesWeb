package main

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"os"
	"strings"
)

// CORSMiddleware é um wrapper que adiciona cabeçalhos CORS
func CORSMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// 1. Permite acesso de qualquer origem (*).
		// Em produção, você deve substituir "*" pelo endereço do seu Flutter (Ex: 192.168.99.XXX:8081)
		w.Header().Set("Access-Control-Allow-Origin", "*")

		// 2. Permite os métodos HTTP que você usará (POST, GET, OPTIONS).
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

		// 3. Permite os cabeçalhos padrão e o Content-Type (essencial para JSON POST)
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		// 4. Se a requisição for OPTIONS (preflight request), retorne o sucesso imediatamente.
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}
		// 5. Passa a requisição para o próximo handler (ObtemCod ou IncluiSolicitacao)
		next.ServeHTTP(w, r)
	})
}

func main() {
	// http.HandleFunc("/solicitacao/obtemcod", ObtemCod)
	// http.HandleFunc("/solicitacao/incluir", IncluiSolicitacao)
	// http.ListenAndServe(":8080", nil)
	router := http.NewServeMux()

	// 2. Define seus handlers (funções) no roteador
	router.HandleFunc("/login", login)
	router.HandleFunc("/acessos", obtemAcessos)
	router.HandleFunc("/usuarios/incluir", IncluirUsuario)
	router.HandleFunc("/usuarios/consulta", consultaUsuario)
	router.HandleFunc("/usuarios/alterar", alteraUsuario)
	router.HandleFunc("/usuarios/alterarsenha", alteraSenha)
	router.HandleFunc("/usuarios/acessos", obtemAcessosUser)
	router.HandleFunc("/solicitacao/obtemcod", ObtemCod)
	router.HandleFunc("/solicitacao/incluir", IncluirSolicitacao)
	router.HandleFunc("/solicitacao/consultar", ConsultarSolicitacoes)
	router.HandleFunc("/solicitacao/obtemsolic", ObtemSolic)
	router.HandleFunc("/solicitacao/anexo", DownloadAnexo)
	router.HandleFunc("/solicitacao/status", altStatus)
	router.HandleFunc("/solicitacao/ticket", incluiTicket)

	//router.HandleFunc("/solicitacao/consultarTodas", ConsultarSolicitacoes)
	// 3. Envolve o roteador com o middleware CORS
	handler := CORSMiddleware(router)
	// O ListenAndServe agora usa o handler com CORS
	http.ListenAndServe(":8080", handler)
}

func incluiTicket(w http.ResponseWriter, r *http.Request) {
	var ticket Ticket
	var solicitacao SolicitacaoSave
	var listaAnexos []string

	err := json.NewDecoder(r.Body).Decode(&ticket)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	log.Print("recebeu o ticket", ticket)

	dir := diretorio + ticket.Ctr + "/"
	dirAnexos := dir + "anexos/"
	nomeArq := ticket.Cod + ".json"

	solicData, err := ler(dir + nomeArq)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON da Solicitação: "+err.Error(), nil)
		return
	}

	err = json.Unmarshal(solicData, &solicitacao)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar o JSON da Solicitação: "+err.Error(), nil)
		return
	}

	log.Println("Pegou a solicitacao", solicitacao)

	if len(ticket.Anexos) != 0 {
		for _, anexo := range ticket.Anexos {
			for nomeArquivo, conteudo := range anexo {
				err = gravar(dirAnexos, "ticket_"+ticket.Cod+"_"+nomeArquivo, conteudo.Bytes)
				if err != nil {
					JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar anexo: "+err.Error(), http.StatusInternalServerError)
					return
				}
				listaAnexos = append(listaAnexos, dirAnexos+"ticket_"+ticket.Cod+"_"+nomeArquivo)
			}
		}
	}

	log.Println("Vai fazer um for ate i ser maior que ", len(solicitacao.Tickets))

	for i := 0; i <= len(solicitacao.Tickets); i++ {
		log.Print("Entrou no for onde i = ", i)
		if i == len(solicitacao.Tickets) {
			log.Print("Entrou no if onde i = ", i, "é maior que ", len(solicitacao.Tickets))
			ticket.Cod = StrZero((i + 1), 5, 0)
			log.Print("Converteu o i para ", ticket.Cod)
			var ticketSave = TicketSalvar{
				Cod:         ticket.Cod,
				Ctr:         ticket.Ctr,
				Emissao:     ticket.Emissao,
				Solicitante: ticket.Solicitante,
				Descricao:   ticket.Descricao,
				Anexos:      listaAnexos,
			}
			solicitacao.Tickets = append(solicitacao.Tickets, ticketSave)
			break
		}
	}

	dataSolic, err := json.Marshal(solicitacao)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao codificar Solicitacao: "+err.Error(), nil)
		return
	}

	gravar(dir, nomeArq, dataSolic)

	log.Print("Gravou a solicitacao com essas informacoes : ", solicitacao)

	JSONResponse(w, http.StatusOK, true, "Ticket Cadastrado", nil)

}

func altStatus(w http.ResponseWriter, r *http.Request) {
	var solic SolicitacaoSave
	var solicitacao SolicitacaoSave
	var listaSolic []SolicitacaoUser
	var solicLista SolicitacaoUser
	var solicSave SolicitacaoSave

	err := json.NewDecoder(r.Body).Decode(&solic)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	dir := diretorio + solic.Ctr + "/"
	nomeArq := solic.Cod + ".json"

	solicData, err := ler(dir + nomeArq)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON da Solicitação: "+err.Error(), nil)
		return
	}

	err = json.Unmarshal(solicData, &solicitacao)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar o JSON da Solicitação: "+err.Error(), nil)
		return
	}
	if strings.ToLower(solic.Status) == "desenvolvimento" {
		solicSave = SolicitacaoSave{
			Cod:         solicitacao.Cod,
			Ctr:         solicitacao.Ctr,
			Solicitante: solicitacao.Solicitante,
			DataEmissao: solicitacao.DataEmissao,
			DataAceito:  solic.DataAceito,
			Tecnico:     solic.Tecnico,
			Status:      solic.Status,
			Prioridade:  solicitacao.Prioridade,
			Descricao:   solicitacao.Descricao,
			Solucao:     solicitacao.Solucao,
			Anexos:      solicitacao.Anexos,
			Tickets:     solicitacao.Tickets,
		}
		solicLista = SolicitacaoUser{
			Cod:         solicitacao.Cod,
			Ctr:         solicitacao.Ctr,
			Solicitante: solicitacao.Solicitante,
			DataEmissao: solicitacao.DataEmissao,
			DataAceito:  solic.DataAceito,
			Status:      solic.Status,
			Prioridade:  solicitacao.Prioridade,
			Descricao:   solicitacao.Descricao,
		}

	} else if strings.ToLower(solic.Status) == "concluido" {
		solicSave = SolicitacaoSave{
			Cod:           solicitacao.Cod,
			Ctr:           solicitacao.Ctr,
			Solicitante:   solicitacao.Solicitante,
			DataEmissao:   solicitacao.DataEmissao,
			DataAceito:    solicitacao.DataAceito,
			Tecnico:       solicitacao.Tecnico,
			DataConclusao: solic.DataConclusao,
			Dev:           solic.Dev,
			Status:        solic.Status,
			Prioridade:    solicitacao.Prioridade,
			Descricao:     solicitacao.Descricao,
			Solucao:       solic.Solucao,
			Anexos:        solicitacao.Anexos,
			Tickets:       solicitacao.Tickets,
		}

		solicLista = SolicitacaoUser{
			Cod:         solicitacao.Cod,
			Ctr:         solicitacao.Ctr,
			Solicitante: solicitacao.Solicitante,
			DataEmissao: solicitacao.DataEmissao,
			DataAceito:  solicitacao.DataAceito,
			Status:      solic.Status,
			Prioridade:  solicitacao.Prioridade,
			Descricao:   solicitacao.Descricao,
		}
	} else if strings.ToLower(solic.Status) == "recusada" {
		solicSave = SolicitacaoSave{
			Cod:           solicitacao.Cod,
			Ctr:           solicitacao.Ctr,
			Solicitante:   solicitacao.Solicitante,
			DataEmissao:   solicitacao.DataEmissao,
			DataAceito:    solicitacao.DataAceito,
			Tecnico:       solic.Tecnico,
			DataConclusao: solic.DataConclusao,
			Status:        solic.Status,
			Prioridade:    solicitacao.Prioridade,
			Descricao:     solicitacao.Descricao,
			Solucao:       solic.Solucao,
			Anexos:        solicitacao.Anexos,
			Tickets:       solicitacao.Tickets,
		}

		solicLista = SolicitacaoUser{
			Cod:         solicitacao.Cod,
			Ctr:         solicitacao.Ctr,
			Solicitante: solicitacao.Solicitante,
			DataEmissao: solicitacao.DataEmissao,
			DataAceito:  solicitacao.DataAceito,
			Status:      solic.Status,
			Prioridade:  solicitacao.Prioridade,
			Descricao:   solicitacao.Descricao,
		}

	} else {
		JSONResponse(w, http.StatusInternalServerError, false, "Status invalido", nil)
		return
	}

	dataSolic, err := json.Marshal(solicSave)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao codificar Solicitacao: "+err.Error(), nil)
		return
	}

	err = gravar(dir, nomeArq, dataSolic)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar Solicitacao: "+err.Error(), nil)
		return
	}

	data, err := ler(dir + "listaSolic.json")
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao obter lista de solicitações: "+err.Error(), http.StatusInternalServerError)
		return
	}
	err = json.Unmarshal(data, &listaSolic)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar lista de solicitações: "+err.Error(), http.StatusInternalServerError)
		return
	}

	var sucesso bool = false
	for i := 0; i < len(listaSolic); i++ {
		if listaSolic[i].Cod == solic.Cod && listaSolic[i].Ctr == solic.Ctr {
			listaSolic[i] = solicLista
			sucesso = true
		}
	}

	if sucesso {
		dataList, err := json.Marshal(listaSolic)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao codificar lista de solicitações: "+err.Error(), http.StatusInternalServerError)
			return
		}
		err = gravar(dir, "listaSolic.json", dataList)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar lista de solicitações: "+err.Error(), http.StatusInternalServerError)
			return
		}
		JSONResponse(w, http.StatusOK, true, "Sucesso ao definir Status", nil)
		return
	} else {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao atualizar lista de solicitações: ", http.StatusInternalServerError)
		return
	}

}

func DownloadAnexo(w http.ResponseWriter, r *http.Request) {
	// Vamos pegar os parâmetros via Query String (ex: ?ctr=09999&arquivo=solic_foto.jpg)
	keys := r.URL.Query()
	ctr := keys.Get("ctr")
	nomeArquivo := keys.Get("arquivo")

	if ctr == "" || nomeArquivo == "" {
		http.Error(w, "CTR e Nome do Arquivo são obrigatórios", http.StatusBadRequest)
		return
	}

	// Monta o caminho real do arquivo
	// CUIDADO: Em produção, valide se o nomeArquivo não tem ".." para evitar Path Traversal

	// Verifica se existe
	if _, err := os.Stat(nomeArquivo); os.IsNotExist(err) {
		http.Error(w, "Arquivo não encontrado", http.StatusNotFound)
		return
	}
	w.Header().Set("Content-Disposition", "inline; filename=\""+nomeArquivo+"\"")
	// Mágica do Go: Serve o arquivo com streaming, cache e suporte a range
	http.ServeFile(w, r, nomeArquivo)
}

func ObtemSolic(w http.ResponseWriter, r *http.Request) {
	var solic DadosSolic
	var solicitacao SolicitacaoSave

	err := json.NewDecoder(r.Body).Decode(&solic)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	dir := diretorio + solic.Ctr + "/" + solic.Cod + ".json"

	solicData, err := ler(dir)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON da Solicitação: "+err.Error(), nil)
		return
	}

	err = json.Unmarshal(solicData, &solicitacao)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar o JSON da Solicitação: "+err.Error(), nil)
		return
	}

	JSONResponse(w, http.StatusOK, true, "Sucesso ao obter Solicitação", solicitacao)

}

func obtemAcessosUser(w http.ResponseWriter, r *http.Request) {
	var usuarios Usuarios
	var acessos map[string]string
	var dir string
	var usuario Solicitante

	err := json.NewDecoder(r.Body).Decode(&usuario)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	dir = diretorio + usuario.Ctr + "/usuarios.json"

	data, err := ler(dir)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de usuarios: "+err.Error(), nil)
		return
	}
	err = json.Unmarshal(data, &usuarios)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar o JSON de usuarios: "+err.Error(), nil)
		return
	}

	for i := 0; i < len(usuarios); i++ {
		if usuarios[i].Nome == usuario.Solicitante && usuarios[i].Ctr == usuario.Ctr {
			acessos = usuarios[i].Permissoes
		}
	}
	JSONResponse(w, http.StatusOK, true, "Sucesso ao obter Acessos", acessos)
}

func obtemAcessos(w http.ResponseWriter, r *http.Request) {
	var acessos []string
	var dir string

	dir = diretorio + "acessos.json"

	data, err := ler(dir)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de acessos: "+err.Error(), nil)
		return
	}
	err = json.Unmarshal(data, &acessos)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar o JSON de acessos: "+err.Error(), nil)
		return
	}

	JSONResponse(w, http.StatusOK, true, "", acessos)

}

func login(w http.ResponseWriter, r *http.Request) {
	var usuarios Usuarios
	var usuario DadosLogin

	err := json.NewDecoder(r.Body).Decode(&usuario)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada"+err.Error(), nil)
		return
	}

	dir := diretorio + usuario.Ctr + "/"
	arqUsers := "usuarios.json"

	listUsers, err := ler(dir + arqUsers)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de usuarios"+err.Error(), nil)
		return
	}
	err = json.Unmarshal(listUsers, &usuarios)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de usuarios"+err.Error(), nil)
		return
	}
	for i := 0; i < len(usuarios); i++ {
		if usuarios[i].Nome == usuario.Nome && usuarios[i].Ctr == usuario.Ctr {
			if usuarios[i].Check == usuario.Check {
				JSONResponse(w, http.StatusOK, true, "Login realizado com sucesso", nil)
				return
			}
		}
	}
	JSONResponse(w, http.StatusUnauthorized, false, "Usuário ou senha inválidos", nil)

}

func alteraSenha(w http.ResponseWriter, r *http.Request) {
	var usuario DadosLogin
	var usuarios Usuarios

	err := json.NewDecoder(r.Body).Decode(&usuario)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	dir := diretorio + usuario.Ctr + "/"
	arqUsers := "usuarios.json"

	listUsers, err := ler(dir + arqUsers)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de usuarios: "+err.Error(), nil)
		return
	}
	err = json.Unmarshal(listUsers, &usuarios)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de usuarios: "+err.Error(), nil)
		return
	}
	var sucesso bool = false
	for i := 0; i < len(usuarios); i++ {
		if usuarios[i].Nome == usuario.Nome && usuarios[i].Ctr == usuario.Ctr {
			usuarios[i].Check = usuario.Check
			sucesso = true
		}
	}

	data, err := json.Marshal(usuarios)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao codificar lista de usuarios: "+err.Error(), nil)
		return
	}

	err = gravar(dir, arqUsers, data)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar novas Credenciais: "+err.Error(), nil)
	}

	if sucesso {
		JSONResponse(w, http.StatusOK, true, "Credencias salvas com sucesso", nil)
	} else {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao slavar credenciais: "+err.Error(), nil)
	}

}

func alteraUsuario(w http.ResponseWriter, r *http.Request) {
	var usuariosRequi AlteraUser
	var usuarioNovo Usuario
	var usuarioAntigo Usuario
	var usuarios Usuarios

	err := json.NewDecoder(r.Body).Decode(&usuariosRequi)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	usuarioNovo = usuariosRequi.Novo
	usuarioAntigo = usuariosRequi.Antigo

	if usuarioNovo.Ctr != usuarioAntigo.Ctr {
		JSONResponse(w, http.StatusInternalServerError, false, "Ctr dos usuarios invalidos: ", nil)
		return
	}

	dir := diretorio + usuarioNovo.Ctr + "/"
	arqUsers := "usuarios.json"

	listUsers, err := ler(dir + arqUsers)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de usuarios: "+err.Error(), nil)
		return
	}
	err = json.Unmarshal(listUsers, &usuarios)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de usuarios: "+err.Error(), nil)
		return
	}
	var sucesso bool = false
	for i := 0; i < len(usuarios); i++ {
		if usuarios[i].Nome == usuarioAntigo.Nome && usuarios[i].Ctr == usuarioAntigo.Ctr {
			usuarios[i] = usuarioNovo
			sucesso = true
		}
	}

	data, err := json.Marshal(usuarios)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao codificar lista de usuarios: "+err.Error(), nil)
		return
	}

	err = gravar(dir, arqUsers, data)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro gravar usuario: "+err.Error(), nil)
		return
	}
	if sucesso {
		JSONResponse(w, http.StatusOK, true, "Usuarios alterado com sucesso: ", nil)
	} else {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao alterar Usuarios:", nil)
	}

}

func consultaUsuario(w http.ResponseWriter, r *http.Request) {

	var ctr Ctr
	var usuarios Usuarios
	var usuariosCtr Usuarios
	var ctrs []string

	err := json.NewDecoder(r.Body).Decode(&ctr)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}
	if ctr.Ctr == "09999" {
		dataCtrs, err := ler(diretorio + "ctrs.json")

		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de CTRs: "+err.Error(), nil)
			return
		}

		err = json.Unmarshal(dataCtrs, &ctrs)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de CTRs: "+err.Error(), nil)
			return
		}

		for _, ctr := range ctrs {
			dirSolics := diretorio + ctr + "/usuarios.json"
			_, err = os.Stat(dirSolics)
			if !errors.Is(err, os.ErrNotExist) {
				listUsers, err := ler(dirSolics)
				if err != nil {
					JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de usuarios: "+err.Error(), nil)
					return
				}

				err = json.Unmarshal(listUsers, &usuariosCtr)

				if err != nil {
					JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de usuarios: "+err.Error(), nil)
					return
				}

				usuarios = append(usuarios, usuariosCtr...)

			}
		}

	} else {
		dir := diretorio + ctr.Ctr + "/usuarios.json"

		_, err = os.Stat(dir)
		if !errors.Is(err, os.ErrNotExist) {
			listUsers, err := ler(dir)
			if err != nil {
				JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de usuarios: "+err.Error(), nil)
				return
			}
			err = json.Unmarshal(listUsers, &usuarios)
			if err != nil {
				JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de usuarios: "+err.Error(), nil)
				return
			}
		} else {
			JSONResponse(w, http.StatusOK, true, "Nenhum usuario encontrado para a CTR informado", nil)
		}

	}

	JSONResponse(w, http.StatusOK, true, "Sucesso ao obter lista de usuarios ", usuarios)

}

func IncluirUsuario(w http.ResponseWriter, r *http.Request) {

	var usuario Usuario
	var usuarios Usuarios
	var ctrs []string

	err := json.NewDecoder(r.Body).Decode(&usuario)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}
	dir := diretorio + usuario.Ctr + "/"
	arqUsers := "usuarios.json"

	_, err = os.Stat(dir + arqUsers)
	if !errors.Is(err, os.ErrNotExist) {
		listUsers, err := ler(dir + arqUsers)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de usuarios: "+err.Error(), nil)
			return
		}
		err = json.Unmarshal(listUsers, &usuarios)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de usuarios: "+err.Error(), nil)
			return
		}
	}

	usuarios = append(usuarios, usuario)
	data, err := json.Marshal(usuarios)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao codificar lista de usuarios: "+err.Error(), nil)
		return
	}

	err = gravar(dir, arqUsers, data)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar no arquivo de Usuarios: "+err.Error(), nil)
	}

	///

	_, err = os.Stat(diretorio + "ctrs.json")
	if !errors.Is(err, os.ErrNotExist) {
		listCtrs, err := ler(diretorio + "ctrs.json")
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de CTRs: "+err.Error(), nil)
			return
		}
		err = json.Unmarshal(listCtrs, &ctrs)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de CTRs: "+err.Error(), nil)
			return
		}
	}
	var encontrou = false
	for _, c := range ctrs {
		if c == usuario.Ctr {
			encontrou = true
		}
	}
	if !encontrou {
		ctrs = append(ctrs, usuario.Ctr)
		dataCtr, err := json.Marshal(ctrs)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao codificar lista de CTRs: "+err.Error(), nil)
			return
		}

		err = gravar(diretorio, "ctrs.json", dataCtr)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar no arquivo de CTRs: "+err.Error(), nil)
		}
	}

	JSONResponse(w, http.StatusOK, true, "Sucesso ao cadastrar o Usuarios: ", nil)
}

func ConsultarSolicitacoes(w http.ResponseWriter, r *http.Request) {
	var solicitante Solicitante
	var listaSolic []SolicitacaoUser
	var ctrs []string
	var listaSolicCtr []SolicitacaoUser

	var err = json.NewDecoder(r.Body).Decode(&solicitante)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	if solicitante.Ctr == "09999" {
		dirSolics := diretorio
		dataCtrs, err := ler(dirSolics + "ctrs.json")
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de CTRs: "+err.Error(), nil)
			return
		}

		err = json.Unmarshal(dataCtrs, &ctrs)

		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de CTRs: "+err.Error(), nil)
			return
		}

		for _, ctr := range ctrs {
			dirSolics := diretorio + ctr + "/"
			_, err = os.Stat(dirSolics + "listaSolic.json")
			if !errors.Is(err, os.ErrNotExist) {
				solicData, err := ler(dirSolics + "listaSolic.json")
				if err != nil {
					JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de lista de solicitações: "+err.Error(), nil)
					return
				}

				err = json.Unmarshal(solicData, &listaSolicCtr)
				if err != nil {
					JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar o JSON de lista de solicitações: "+err.Error(), nil)
					return
				}
				listaSolic = append(listaSolic, listaSolicCtr...)
			}
		}
		JSONResponse(w, http.StatusOK, true, "Sucesso ao obter lista de solicitações", listaSolic)
		return
	} else {
		dirSolics := diretorio + solicitante.Ctr + "/"
		_, err = os.Stat(dirSolics + "listaSolic.json")
		if !errors.Is(err, os.ErrNotExist) {
			solicData, err := ler(dirSolics + "listaSolic.json")
			if err != nil {
				JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler o JSON de lista de solicitações: "+err.Error(), nil)
				return
			}
			var listaSolicCtr []SolicitacaoUser
			err = json.Unmarshal(solicData, &listaSolicCtr)
			if err != nil {
				JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar o JSON de lista de solicitações: "+err.Error(), nil)
				return
			}
			if solicitante.Permissoes["Consultar Solicitacoes"] == "geral" {
				JSONResponse(w, http.StatusOK, true, "Sucesso ao obter lista de solicitações", listaSolicCtr)
			} else {
				for _, solic := range listaSolicCtr {
					if solic.Solicitante == solicitante.Solicitante {
						listaSolic = append(listaSolic, solic)
					}
				}
				JSONResponse(w, http.StatusOK, true, "Sucesso ao obter lista de solicitações", listaSolic)
			}
		}
	}

}

func ObtemCod(w http.ResponseWriter, r *http.Request) {
	var ctr Ctr
	var cod CodSolic

	if err := json.NewDecoder(r.Body).Decode(&ctr); err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}
	dir := diretorio + ctr.Ctr + "/"
	dirCod := dir + "nroSolic.json"
	_, err := os.Stat(dirCod)
	if !errors.Is(err, os.ErrNotExist) {
		teste, err := ler(dirCod)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler número da solicitação: "+err.Error(), nil)
			return
		}
		erro := json.Unmarshal(teste, &cod)
		if erro != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar número da solicitação: "+erro.Error(), nil)
			return
		}
	} else {
		cod = CodSolic{"proxCod": 1}
		err = gravar(dir, "nroSolic.json", []byte(`{"proxCod": 1}`))
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar  número da solicitação: "+err.Error(), nil)
		}
	}

	proxCod := StrZero(cod["proxCod"], 5, 0)
	resp := map[string]string{"proxCod": proxCod}

	JSONResponse(w, http.StatusOK, true, "Sucesso ao obter proximo Cod. da Solicitacao", resp)

}

func IncluirSolicitacao(w http.ResponseWriter, r *http.Request) {
	var solicitacao Solicitacao
	var cod CodSolic
	var listaAnexos []string
	var listaSolic []SolicitacaoUser

	if err := json.NewDecoder(r.Body).Decode(&solicitacao); err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar JSON de entrada: "+err.Error(), nil)
		return
	}

	diretorioSolicitacao := diretorio + solicitacao.Ctr + "/"
	diretorioAnexos := diretorio + solicitacao.Ctr + "/anexos/"

	nroa, err := ler(diretorio + solicitacao.Ctr + "/nroSolic.json")
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao ler número da solicitação: "+err.Error(), http.StatusInternalServerError)
		return
	}

	erro := json.Unmarshal(nroa, &cod)
	if erro != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar número da solicitação: "+erro.Error(), http.StatusInternalServerError)
		return
	}

	nomeSolic := solicitacao.Cod

	if len(solicitacao.Anexos) != 0 {
		for _, anexo := range solicitacao.Anexos {
			for nomeArquivo, conteudo := range anexo {
				err = gravar(diretorioAnexos, nomeSolic+"_"+nomeArquivo, conteudo.Bytes)
				if err != nil {
					JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar anexo: "+err.Error(), http.StatusInternalServerError)
					return
				}
				listaAnexos = append(listaAnexos, diretorioAnexos+nomeSolic+"_"+nomeArquivo)
			}
		}
	}

	SolicitacaoSave := SolicitacaoSave{
		Cod:           solicitacao.Cod,
		Ctr:           solicitacao.Ctr,
		Solicitante:   solicitacao.Solicitante,
		DataEmissao:   solicitacao.DataEmissao,
		DataAceito:    solicitacao.DataAceito,
		Tecnico:       solicitacao.Tecnico,
		DataConclusao: solicitacao.DataConclusao,
		Dev:           solicitacao.Dev,
		Status:        solicitacao.Status,
		Prioridade:    solicitacao.Prioridade,
		Descricao:     solicitacao.Descricao,
		Solucao:       solicitacao.Solucao,
		Anexos:        listaAnexos,
	}

	nomeArq := nomeSolic + ".json"

	data, err := json.Marshal(SolicitacaoSave)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao converter solicitação para JSON: "+err.Error(), http.StatusInternalServerError)
		return
	}
	err = gravar(diretorioSolicitacao, nomeArq, data)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar solicitação: "+err.Error(), http.StatusInternalServerError)
		return
	}

	sla := cod["proxCod"] + 1
	proxCod, err := json.Marshal(map[string]int{"proxCod": sla})
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao converter próximo código para JSON: "+err.Error(), http.StatusInternalServerError)
		return
	}

	err = gravar(diretorioSolicitacao, "nroSolic.json", proxCod)
	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar próximo código: "+err.Error(), http.StatusInternalServerError)
		return
	}

	_, err = os.Stat(diretorioSolicitacao + "listaSolic.json")
	if !errors.Is(err, os.ErrNotExist) {
		data, err = ler(diretorioSolicitacao + "listaSolic.json")
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao obter lista de solicitações: "+err.Error(), http.StatusInternalServerError)
			return
		}
		err = json.Unmarshal(data, &listaSolic)
		if err != nil {
			JSONResponse(w, http.StatusInternalServerError, false, "Erro ao decodificar lista de solicitações: "+err.Error(), http.StatusInternalServerError)
			return
		}
	}

	solicitacaoUser := SolicitacaoUser{
		Cod:         solicitacao.Cod,
		Ctr:         solicitacao.Ctr,
		Solicitante: solicitacao.Solicitante,
		DataEmissao: solicitacao.DataEmissao,
		DataAceito:  solicitacao.DataAceito,
		Status:      solicitacao.Status,
		Prioridade:  solicitacao.Prioridade,
		Descricao:   solicitacao.Descricao,
	}

	listaSolic = append(listaSolic, solicitacaoUser)

	data, err = json.Marshal(listaSolic)

	if err != nil {
		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao converter lista de solicitações para JSON: "+err.Error(), http.StatusInternalServerError)

		return
	}

	err = gravar(diretorioSolicitacao, "listaSolic.json", data)

	if err != nil {

		JSONResponse(w, http.StatusInternalServerError, false, "Erro ao gravar lista de solicitações: "+err.Error(), http.StatusInternalServerError)
		return
	}

	JSONResponse(w, http.StatusOK, true, "Solicitação gravada com sucesso", http.StatusOK)

}
