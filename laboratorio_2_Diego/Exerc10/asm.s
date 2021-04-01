        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start

        ;;Ex 10
main    
        MOV R0, #0x12
        MOV R1, #0x0
        MUL R3, R0, R1           ;; verdadeiro resultado, para fazer a prova real
        BL Mul16b
        B fim
        
Mul16b:
        PUSH {R0, R1, R3, LR}    ;; coloca na pilha
        MOV R2, #0               ;; para garantir que R2 comece zerado, afinal nossa resposta da multiplicação estará nele
        MOV R3, #16              ;; número de bits, no nosso caso, 16 bits
loop
        CBZ R3, saida            ;; verifica se o R3 já é zero, ou seja, se foi feita a multiplicação dos 16 bits
        LSRS R1, R1, #1          ;; empura 1 bit à direita o R1, afetando o carry flag
        IT CS                    ;; se o carry flag estiver setado, ir a instrução ADDCS
        ADDCS R2, R2, R0         ;; R2 := R2 + R0
        IT EQ                    ;; verifica se o Z=1, ou seja, quando o R1 for 0 
        BEQ saida                ;; se z=1 então a multiplicação já terminou, ou seja, podemos sair da subrotina
        LSL R0, R0, #1           ;; empurra 1 bit à esquerda o R0, sem afetar o carry flag
        SUB R3, R3, #1           ;; R3 := R3-1, caso os números sejam de 16 bits, chegaremos até R3 = 0
        B loop

saida
        POP {R0, R1, R3, PC}     ;; tira da pilha
        
fim
        B .
        
        ;;Ex11
;;main
        ;;MOV R0, #0x11111111
        ;;BL Fat32b
        ;;B fim
        
;;Fat32b:
        ;;PUSH {LR}
        ;;MOV LR, R0
;;loop          
        ;;SUBS LR, LR, #1 
        ;;BEQ pula
        ;;MUL R0, R0, LR
        ;;B loop
;;pula    
        ;;POP {LR}
        ;;BX LR
        
;;fim
        ;;B .
        
        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
