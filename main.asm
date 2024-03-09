.data
	intro: .asciiz "Bem-vindo a lista de afazeres.\n"
	options: .asciiz "Selecione a opcao:\n1.Ver tarefas\n2.Criar tarefa.\n3.Marcar tarefa como completa\n4.Editar tarefa\n5.Remover tarefa\n0.Sair\n"
	finishOpText: .asciiz "Operação concluída com suceso\n\n"
	errorOpText: .asciiz "Houve um erro com a operacao\n\n"
	errorSelectionText: .asciiz "Numero invalido. Por favor digite um numero valido.\n\n"

.text
start:
	li $v0, 4
	la $a0, intro
	syscall
menu:
	#chama lista de opcoes
	li $v0, 4
	la $a0, options
	syscall
	
	#aguarda input do usuario
	li $v0, 5
	syscall
	move $s0, $v0
	
	optionSelection:
	#se valor errado, manda para erro	
	bgt $s0, 5, errorSelection
	bltz $s0, errorSelection 

	#seleciona opcao correta
	beq $s0, 1, canListTasks
	beq $s0, 2, canCreateTask
	beq $s0, 3, canCompleteTask
	beq $s0, 4, canEditTask
	beq $s0, 5, canRemoveTask
	beq $s0, 0, finish
	
errorSelection:
	li $v0, 4
	la $a0, errorSelectionText
	syscall
	li $v0, 0
	j opEnd
	
canListTasks:
	jal listTasks
	j opEnd

canCreateTask:
	jal createTask
	j opEnd

canCompleteTask:
	jal completeTask
	j opEnd
	
canEditTask:
	jal editTask
	j opEnd
	
canRemoveTask:
	jal removeTask
	j opEnd
	
finish: 
	li $v0, 10
	syscall
	
	opEnd:
	#finaliza operação e segue para menu
	beqz $v0, hasError
	li $v0, 4
	la $a0, finishOpText
	syscall
	j menu
	
hasError:
	li $v0, 4
	la $a0, errorOpText
	syscall
	j menu	
	
#funções
	
#Função que lista todas tarefas
listTasks:
	jr $ra

#Função que cria uma nova tarefa
createTask:
	jr $ra

#Função que completa uma tarefa pendente
completeTask:
	jr $ra

#Função que edita uma tarefa existente
editTask:
	jr $ra
	
#Função que remove uma tarefa
removeTask:
	jr $ra

	