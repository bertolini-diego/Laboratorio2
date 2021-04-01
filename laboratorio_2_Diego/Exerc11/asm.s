        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
        ;;Ex11
main
        MOV R0, #0x8                       ;; número de teste (13)
        BL Fat32b                          ;; entrada pra sub-rotina
        B fim                              ;; fim
        
        ;; 12 é o último número que não dará -1, ou seja, a partir do 13, todos resultados serão -1. 
Fat32b:
        PUSH {R1,R2,R3,LR}                 ;; coloca o R1, R2, R3 e LR na pilha, guardando pra traze-los depois 

        ;; Parte da sub-rotina que ve se o resultado é negativo (usa os registradores R
        MOV R3, #0xc                       ;; coloca em R3 o valor máximo, que é 12
        MOV R2, R0                         ;; R2 := R0
        SUBS R2, R3, R0                    ;; R2 := R3 - R0 // será negativo se R0 for maior que 12, assim
        ITT MI                             ;; entra na condicional
        MOVMI R0, #-1                      ;; coloca -1 em R0 por ser um número que estoura a capacidade permitida
        BMI pula                           ;; pula
        
        MOV R1, R0                         ;; R1 := R0
        CMP R0, #0                         ;; compara pra ver se o R0 é igual a zero e afeta o flag Z se positivo
        ITT EQ                             ;; se Z for igual a 1 então 
        MOVEQ R0, #1                       ;; coloca o resultado como 1 
        BEQ pula                           ;; pula para a saida
loop                 
        SUBS R1, R1, #1                    ;; subtrai um bit de R1
        BEQ pula                           ;; pula quando Z=1, ou seja, R1 := 0
        MULS R0, R0, R1                    ;; multiplica R0 e R1
        B loop
pula    
        POP {R1,R2,R3,LR}                  ;; retira os valores de R1, R2, R3 e LR da pilha pra coloca-los em seu devido lugar
        BX LR                              ;; return
        
fim
        B .

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
