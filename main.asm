.data
	#Dados na memoria
	titles: .space 5120
	completed: .space 20
	
	matrix:
		.word titles
		.word completed

  task_count: .word 0
  
  newline: .asciiz "\n"
  
  #Prompts Listar Tarefas / Criar tarefa
  tag0: .asciiz "\nTarefa "
  tag1: .asciiz ": "

  nome: .asciiz "\nNome da tarefa: "    # Prompt para o nome da tarefa
  completa: .asciiz "Status (0: incompleta / 1: completa): "
	sem_tarefas: .asciiz "\nSem tarefas para exibir.\n"

  add_prompt: .asciiz "Digite a nova tarefa: "
  task_content: .asciiz "Nova Tarefa\n"
  
  #Prompts menu
	intro: .asciiz "Bem-vindo a lista de afazeres.\n"
	options: .asciiz "Selecione a opcao:\n1.Ver tarefas\n2.Criar tarefa.\n3.Marcar tarefa como completa\n4.Editar tarefa\n5.Remover tarefa\n0.Sair\n"
	finishOpText: .asciiz "\n\nOperação concluída com sucesso\n\n"
	errorOpText: .asciiz "Houve um erro com a operação\n\n"
	errorSelectionText: .asciiz "Número inválido. Por favor, digite um número válido.\n\n"
	
	Id_selection_text: .asciiz "\nDigite o Id da tarefa "
	idError: .asciiz "Id nao encontrado para a tarefa desejada"

.text
start:
    li $v0, 4
    la $a0, intro
    syscall
menu:
    # chama lista de opções
    li $v0, 4
    la $a0, options
    syscall
    
    # aguarda input do usuário
    li $v0, 5
    syscall
    move $s0, $v0
    
optionSelection:
    # se valor errado, manda para erro	
    bgt $s0, 5, errorSelection
    bltz $s0, errorSelection 

    # seleciona opção correta
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
    # finaliza operação e segue para menu
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
    
# funções
    
# Função para criar uma nova tarefa
createTask:
		# Carrega dados
		lw $t0, task_count #quantidade de tarefas já existentes
		la $t1, matrix #endereço base da matriz
		lw $t2, 0($t1) #endereço base dos nomes das tarefas
		lw $t3, 4($t1) #endereço base para status das tarefas
		sll $t4, $t0, 8 # calculo offset nome
		
    # Mostra o prompt para o nome da tarefa
    li $v0, 4                 
    la $a0, nome
    syscall
    
    # Lê o nome da tarefa
    li $v0, 8
    add $a0, $t2, $t4    # Offset do prox endereço livre para nome
    li $a1, 256        # Tamanho do nome
    syscall
    
    # Salva o status como incompleto (0)
    add $t5, $t3, $t0    # offset p prox endereço livre para status
    sb $zero, 0($t5)     # Initialize completion status to 0 (not completed)

    # Incrementa o contador de tarefas
    addi $t0, $t0, 1
    sw $t0, task_count
    
    jr $ra
    
listTasks:
    # Load the task count
    lw $t0, task_count
    
    # Check if there are any tasks
    beqz $t0, no_tasks
    
    # Load the base address of the matrix
    la $t1, matrix
    
    # Load the base address of the task names
    lw $t2, 0($t1)
    
    # Load the base address of the task statuses
    lw $t3, 4($t1)
    
    # Loop through tasks
    li $t4, 0      # Loop counter
    task_loop:
        # Check if the loop counter is equal to the task count
        beq $t4, $t0, end_loop
        
        # Print task number
        li $v0, 4
        la $a0, tag0
        syscall
        li $v0, 1
        move $a0, $t4
        syscall
        li $v0, 4
        la $a0, tag1
        syscall
        
        # Print task name
        li $v0, 4
        move $a0, $t2    # Load task name address
        syscall
        
        # Print status text
        li $v0, 4
        la $a0, completa
        syscall
        
        # Print task status
        li $v0, 1
        lb $a0, 0($t3)    # Load task status
        syscall
        
        # criar nova linha
        li $v0, 4
        la $a0, newline
        syscall
        
        # Move to the next task
        addi $t4, $t4, 1
        addi $t2, $t2, 256  # Move to the next task name
        addi $t3, $t3, 1    # Move to the next task status
        j task_loop
    
    end_loop:
    jr $ra
    
no_tasks:
    # Print message indicating no tasks
    li $v0, 4
    la $a0, sem_tarefas
    syscall
    
    jr $ra

# Função que completa uma tarefa pendente
completeTask:
    jr $ra
    
editTask:
	jr $ra

# Função que remove uma tarefa
removeTask:
	jr $ra
