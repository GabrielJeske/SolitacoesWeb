package main

// type ListaSolic []string

// type SolicitacoesUsuario map[string]ListaSolic
type CodSolic map[string]int

type ProximoNro map[string]string

type AnexoData struct {
	Bytes []byte `json:"bytes"`
}

type AnexoMapa map[string]AnexoData

type Ctr struct {
	Ctr string `json:"ctr"`
}

type Solicitacao struct {
	Cod           string                 `json:"cod"`
	Ctr           string                 `json:"ctr"`
	Solicitante   string                 `json:"solicitante"`
	DataEmissao   string                 `json:"dataEmissao"`
	DataAceito    string                 `json:"dataAceito"`
	Tecnico       string                 `json:"tecnico"`
	DataConclusao string                 `json:"dataConclusao"`
	Dev           string                 `json:"dev"`
	Status        string                 `json:"status"`
	Prioridade    string                 `json:"prioridade"`
	Descricao     string                 `json:"descricao"`
	Solucao       string                 `json:"solucao"`
	Anexos        []map[string]AnexoData `json:"anexos"`
	Tickets       []Ticket               `json:"tickets"`
}

type SolicitacaoSave struct {
	Cod           string         `json:"cod"`
	Ctr           string         `json:"ctr"`
	Solicitante   string         `json:"solicitante"`
	DataEmissao   string         `json:"dataEmissao"`
	DataAceito    string         `json:"dataAceito"`
	Tecnico       string         `json:"tecnico"`
	DataConclusao string         `json:"dataConclusao"`
	Dev           string         `json:"dev"`
	Status        string         `json:"status"`
	Prioridade    string         `json:"prioridade"`
	Descricao     string         `json:"descricao"`
	Solucao       string         `json:"solucao"`
	Anexos        []string       `json:"anexos"`
	Tickets       []TicketSalvar `json:"tickets"`
}

type Ticket struct {
	Cod         string                 `json:"cod"`
	Ctr         string                 `json:"ctr"`
	Emissao     string                 `json:"emissao"`
	Solicitante string                 `json:"solicitante"`
	Descricao   string                 `json:"descricao"`
	Anexos      []map[string]AnexoData `json:"anexos"`
}

type TicketSalvar struct {
	Cod         string   `json:"cod"`
	Ctr         string   `json:"ctr"`
	Emissao     string   `json:"emissao"`
	Solicitante string   `json:"solicitante"`
	Descricao   string   `json:"descricao"`
	Anexos      []string `json:"anexos"`
}

type SolicitacaoUser struct {
	Cod         string `json:"cod"`
	Ctr         string `json:"ctr"`
	Solicitante string `json:"solicitante"`
	DataEmissao string `json:"dataEmissao"`
	DataAceito  string `json:"dataAceito"`
	Status      string `json:"status"`
	Prioridade  string `json:"prioridade"`
	Descricao   string `json:"descricao"`
}

// Estrutura de INPUT para o POST de consulta
type Solicitante struct {
	Ctr         string            `json:"ctr"`
	Solicitante string            `json:"nome"`
	Permissoes  map[string]string `json:"permissoes"`
}

type DadosSolic struct {
	Ctr string `json:"ctr"`
	Cod string `json:"cod"`
}

type ListaSolicitacoes struct {
	Usuario []string `json:"usuario"`
}

type Usuarios []Usuario

type Usuario struct {
	Ctr        string            `json:"ctr"`
	Nome       string            `json:"nome"`
	Check      string            `json:"check"`
	Cel        string            `json:"cel"`
	Email      string            `json:"email"`
	Cargo      string            `json:"cargo"`
	Permissoes map[string]string `json:"permissoes"`
}

type AlteraUser struct {
	Antigo Usuario `json:"antigo"`
	Novo   Usuario `json:"novo"`
}

type DadosLogin struct {
	Ctr   string `json:"ctr"`
	Nome  string `json:"nome"`
	Check string `json:"check"`
}

type DefaultResponse struct {
	Sucesso  bool        `json:"sucesso"`
	Mensagem string      `json:"mensagem"`
	Data     interface{} `json:"data"`
}
