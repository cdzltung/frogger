#####################################################################
#
# CSC258H5S Winter 2022 Assembly Final Project
# University of Toronto, St. George
#
# Student: Carmel Tung, 1006845611
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5 (All Milestones reached)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Display the number of lives remaining
# 2. After final player death, display game retry screen. Restart if retry option chosen
# 3. Dynamic increase in difficulty (speed) as game progresses (with each goal)
# 4. Have objects in different rows move at different speeds
# 5. Add sound effects for movement, losing lives, collisions, and reaching goal
# 6. Make the frog point in the direction that it's travelling
# 7. Displaying a pause image when 'p' is pressed, return to game when 'p' pressed again
#
#
# Any additional information that the TA needs to know:
# - Thank you for the good demo sessions and for a good CSC258 experience
#
#####################################################################

.data
displayAddress: .word 0x10008000
carRow1: .space 512
carRow2: .space 512
riverRow1: .space 512
riverRow2: .space 512
safeRow: .space 512
startRow: .space 512
green: .word 0x00ff00
orange: .word 0xffa000
blue: .word 0x407d80
yellow: .word 0xffff00
black: .word 0x000000
red: .word 0xff0000
frog_og_x: .word 16
frog_og_y: .word 28
frog_x: .word 16
frog_y: .word 28
frog_og_orientation: .word 1
frog_orientation: .word 1
goals: .word 0

.text
Start:
li $t9, 0
li $s2, 0
lw $t1, green
lw $t2, yellow
la $t8, safeRow
jal draw_safe_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_safe_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_safe_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_safe_line

la $t8, safeRow
addi $t8, $t8, 64
add $t5, $zero, $zero
jal draw_safe_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_safe_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_safe_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_safe_line

add $t5, $zero, $zero
la $t8, startRow
la $t2, startRow
lw $t1, green
fill_start_row:
beq $t5, 512, end_fill_start_row
add $t2, $t8, $t5
sw $t1, 0($t2)
add $t5, $t5, 4
j fill_start_row
end_fill_start_row:
lw $t1, yellow
la $t8, startRow
addi $t8, $t8, 384
sw $t1, 0($t8)
addi $t8, $t8, 8
sw $t1, 0($t8)
addi $t8, $t8, 8
sw $t1, 0($t8)


li $t1, 0
li $t2, 0
li $t8, 0
li $t5, 0

Spawn:
li $s7, 16
######################################################################
# DRAWING THE MAP #1
######################################################################
# $t0 stores the base address for display
# $t1 stores the colour code
# $t2 stores the frog's location
# $t3, $t4 used to calculate the offsets  
lw $t0, displayAddress # $t0 stores the base address for display
li $t1, 0x00ff00 # $t1 stores the red colour code
add $t5, $zero, $zero
add $t6, $zero, $zero
addi $a0, $zero, 8
addi $a1, $zero, 32
jal draw_land

addi $t0, $t0, 1024

addi $t6, $zero, 0
li $t1, 0xffff00
addi $a0, $zero, 4
jal draw_land



lw $t0, displayAddress
lw $t3, frog_og_y
sw $t3, frog_y
la $t3, frog_y
lw $t4, 0($t3)
lw $t3, frog_og_x
sw $t3, frog_x
la $t3, frog_x
lw $t5, 0($t3)
sll $t4, $t4, 7
sll $t5, $t5, 2
add $t2, $t0, $t4
add $t2, $t2, $t5
li $t1, 0xffa500
lw $s6, frog_og_orientation
la $s5, frog_orientation
sw $s6, 0($s5)
jal draw_frog

li $t0, 0
li $t3, 0
li $t4, 0
li $t5, 0
li $t1, 0

######################################################################
# LOAD THE ROW ARRAYS
######################################################################
# $t8 holds the address of the memory 
# $t5 is a counter that will be incremented
# t6 is the ceiling the counter will hit
# $t1 holds color 1
# $t2 holds color 2
li $t1, 0x964b00
li $t2, 0x0000ff
la $t8, riverRow1
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, riverRow1
addi $t8, $t8, 64
add $t5, $zero, $zero
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, riverRow1

li $t2, 0x964b00
li $t1, 0x0000ff
la $t8, riverRow2
add $t5, $zero, $zero
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, riverRow2
addi $t8, $t8, 64
add $t5, $zero, $zero
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, riverRow2

li $t2, 0x000000
li $t1, 0xff0000
la $t8, carRow1
add $t5, $zero, $zero
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, carRow1
addi $t8, $t8, 64
add $t5, $zero, $zero
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, carRow1

li $t1, 0x000000
li $t2, 0xff0000
la $t8, carRow2
add $t5, $zero, $zero
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, carRow2
addi $t8, $t8, 64
add $t5, $zero, $zero
jal draw_river_line 
add $t5, $zero, $zero
addi $t8, $t8, 128 				
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
add $t5, $zero, $zero
addi $t8, $t8, 128
jal draw_river_line
la $t8, carRow2


j main


draw_river_line:
beq $t5, 2, end_draw_river_line_1
sw $t1, 0($t8)
sw $t1, 4($t8)
sw $t1, 8($t8)
sw $t1, 12($t8)
sw $t1, 16($t8)
sw $t1, 20($t8)
sw $t1, 24($t8)
sw $t1, 28($t8)
sw $t2, 32($t8)
sw $t2, 36($t8)
sw $t2, 40($t8)
sw $t2, 44($t8)
sw $t2, 48($t8)
sw $t2, 52($t8)
sw $t2, 56($t8)
sw $t2, 60($t8)
addi $t5, $t5, 1
# addi $t8, $t8, 64
j draw_river_line
end_draw_river_line_1:
jr $ra 

draw_safe_line:
beq $t5, 2, end_draw_safe_line_1
sw $t1, 0($t8)
sw $t1, 4($t8)
sw $t1, 8($t8)
sw $t1, 12($t8)
sw $t2, 16($t8)
sw $t2, 20($t8)
sw $t2, 24($t8)
sw $t2, 28($t8)
sw $t1, 32($t8)
sw $t1, 36($t8)
sw $t1, 40($t8)
sw $t1, 44($t8)
sw $t2, 48($t8)
sw $t2, 52($t8)
sw $t2, 56($t8)
sw $t2, 60($t8)
addi $t5, $t5, 1
# addi $t8, $t8, 64
j draw_safe_line
end_draw_safe_line_1:
jr $ra

li $s0, 0

main:
######################################################################
# CHECK KEYBOARD INPUT
######################################################################
# $t8 holds the memory address of the last keyboard input
lw $t0, displayAddress
li $t5, 0
li $t8, 0
li $t2, 0
li $t1, 0
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input
j use_arrays_to_color_in_rows

keyboard_input:
lw $t9, 0xffff0004
li $v0, 31
li $a0, 81
li $a1, 500
li $a2, 24
li $a3, 50
syscall

beq $t9, 0x61, respond_to_A
beq $t9, 0x73, respond_to_S
beq $t9, 0x64, respond_to_D
beq $t9, 0x77, respond_to_W
beq $t9, 0x71, respond_to_Q
beq $t9, 0x70, respond_to_P

respond_to_A:
lw $t0, displayAddress
la $t3, frog_x
lw $t5, 0($t3)
addi $t5, $t5, -2
sw $t5, frog_x
la $s5, frog_orientation
li $s4, 2
sw $s4, 0($s5)
j use_arrays_to_color_in_rows

respond_to_S:
lw $t0, displayAddress
la $t3, frog_y
lw $t5, 0($t3)
addi $t5, $t5, 2
sw $t5, frog_y
la $s5, frog_orientation
li $s4, 4
sw $s4, 0($s5)
j use_arrays_to_color_in_rows

respond_to_D:
lw $t0, displayAddress
la $t3, frog_x
lw $t5, 0($t3)
addi $t5, $t5, 2
sw $t5, frog_x
la $s5, frog_orientation
li $s4, 3
sw $s4, 0($s5)
j use_arrays_to_color_in_rows

respond_to_W:
lw $t0, displayAddress
la $t3, frog_y
lw $t5, 0($t3)
addi $t5, $t5, -2
sw $t5, frog_y
la $s5, frog_orientation
li $s4, 1
sw $s4, 0($s5)
j use_arrays_to_color_in_rows

respond_to_Q:
li $t8, 0
li $t1, 0
j Exit

respond_to_P:
j Pause

use_arrays_to_color_in_rows:
li $t5, 0
li $t8, 0
li $t4, 0
li $t9, 0
li $t2, 0
li $t1, 0


######################################################################
# USE ARRAYS TO COLOR IN ROWS
######################################################################
# $t8 holds the address of the memory 
# $t5 is a counter that will be incremented
# t6 is the ceiling the counter will hit

color_rows_in:
la $t8, safeRow
add $t5, $zero, $zero
addi $t6, $zero, 512
lw $t2, displayAddress
jal paint_river

la $t8, riverRow1
add $t5, $zero, $zero
addi $t6, $zero, 512
lw $t2, displayAddress
addi $t2, $t2, 1024
jal paint_river

la $t8, riverRow2
add $t5, $zero, $zero
addi $t6, $zero, 512
lw $t2, displayAddress
addi $t2, $t2, 1536
jal paint_river

la $t8, carRow1
add $t5, $zero, $zero
addi $t6, $zero, 512
lw $t2, displayAddress
addi $t2, $t2, 2560
jal paint_river

la $t8, carRow2
add $t5, $zero, $zero
addi $t6, $zero, 512
lw $t2, displayAddress
addi $t2, $t2, 3072
jal paint_river

la $t8, startRow
add $t5, $zero, $zero
addi $t6, $zero, 512
lw $t2, displayAddress
addi $t2, $t2, 3584
jal paint_river

j drawMap

paint_river:
bge $t5, $t6, end_paint_river
lw $t4, 0($t8)
sw $t4, 0($t2)
addi $t2, $t2, 4
addi $t5, $t5, 4
addi $t8, $t8, 4
j paint_river
end_paint_river:
jr $ra
######################################################################
# DRAWING THE MAP
######################################################################
# $t0 stores the base address for display
# $t1 stores the colour code
# $t2 stores the frog's location
# $t3, $t4 used to calculate the offsets  
drawMap:
lw $t0, displayAddress # $t0 stores the base address for display
addi $t0, $t0, 512
li $t1, 0x00ff00 # $t1 stores the red colour code
add $t5, $zero, $zero
add $t6, $zero, $zero
addi $a0, $zero, 4
addi $a1, $zero, 32
jal draw_land

addi $t0, $t0, 1024

addi $t6, $zero, 0
lw $t1, green
addi $a0, $zero, 4
jal draw_land

addi $t0, $t0, 1024


lw $t0, displayAddress
la $t3, frog_y
lw $t4, 0($t3)
la $t3, frog_x
lw $t5, 0($t3)
sll $t4, $t4, 7
sll $t5, $t5, 2
add $t2, $t0, $t4
add $t2, $t2, $t5
li $t1, 0xffa500
jal draw_frog

li $t5, 0
li $t8, 0
li $t4, 0
li $t9, 0
li $t2, 0
li $t1, 0

######################################################################
# COLLISION DETECTION
######################################################################
lw $t0, displayAddress
la $t3, frog_y
lw $t4, 0($t3)
la $t3, frog_x
lw $t5, 0($t3)
sll $t4, $t4, 7
sll $t5, $t5, 2
add $t2, $t0, $t4
add $t2, $t2, $t5
addi $t8, $t0, 16
beq $t2, $t8, Goal
addi $t8, $t0, 48
beq $t2, $t8, Goal
addi $t8, $t0, 80
beq $t2, $t8, Goal
addi $t8, $t0, 112
beq $t2, $t8, Goal
addi $t2, $t2, 4
lw $t1, 0($t2)
lw $t6, red
lw $t7, blue
beq $t1, $t6, Death
beq $t1, $t7, Death
addi $t2, $t2, 384
lw $t1, 0($t2)
beq $t1, $t6, Death
beq $t1, $t7, Death


li $t5, 0
li $t6, 0
li $t8, 0
li $t4, 0
li $t9, 0
li $t2, 0
li $t1, 0


######################################################################
# SHIFTING THE ARRAYS
######################################################################
# $t8 holds the memory address of the array
run1:
beq $s0, 0, run_riverRow1

run2:
beq $s0, 7, run_riverRow2
beq $s0, 6, run_riverRow2

run3:
beq $s0, 1, run_carRow1
beq $s0, 3, run_carRow1

run4:
beq $s0, 3, run_carRow2
j turn_values


run_riverRow1:
la $t8, riverRow1
addi $t8, $t8, 508
addi $t5, $zero, 508
jal shift_array_right
j run2


run_riverRow2:
la $t8, riverRow2
addi $t8, $t8, 0
addi $t5, $zero, 0
jal shift_array_left
j run3

run_carRow1:
la $t8, carRow1
addi $t8, $t8, 508
addi $t5, $zero, 508
jal shift_array_right
j run4


run_carRow2:
la $t8, carRow2
addi $t8, $t8, 0
addi $t5, $zero, 0
jal shift_array_left


turn_values:
beq $s0, 0, turn_1
beq $s0, 1, turn_2
beq $s0, 2, turn_3
beq $s0, 3, turn_4
beq $s0, 4, turn_5
beq $s0, 5, turn_6
beq $s0, 6, turn_7
beq $s0, 7, turn_8
beq $s0, 8, turn_0

turn_8:
li $s0, 8
j end

turn_7:
li $s0, 7
j end

turn_6:
li $s0, 6
j end

turn_5:
li $s0, 5
j end

turn_4:
li $s0, 4
j end

turn_3:
li $s0, 3
j end

turn_2:
li $s0, 2
j end

turn_1:
li $s0, 1
j end

turn_0:
li $s0, 0
j end


end:
li $v0, 32
li $a0, 16
syscall
j main


shift_array_right:
beq, $t5, 0, end_shift_array_right
addi $t8, $t8, -4
addi $t5, $t5, -4
lw $t6, 0($t8)
sw $t6, 4($t8)
j shift_array_right
end_shift_array_right:
lw $t9, 128($t8)
sw $t9, 0($t8)
jr $ra

shift_array_left:
beq, $t5, 508, end_shift_array_left
lw $t6, 4($t8)
sw $t6, 0($t8)
addi $t8, $t8, 4
addi $t5, $t5, 4
j shift_array_left
end_shift_array_left:
lw $t9, -128($t8)
sw $t9, 0($t8)
jr $ra

draw_frog:
lw $s5, frog_orientation
beq $s5, 1, frog_forward
beq $s5, 4, frog_backward
beq $s5, 2, frog_left
beq $s5, 3, frog_right
frog_forward:
sw $t1, 0($t2)
sw $t1, 12($t2)
sw $t1, 128($t2)
sw $t1, 132($t2)
sw $t1, 136($t2)
sw $t1, 140($t2)
sw $t1, 260($t2)
sw $t1, 264($t2)
sw $t1, 384($t2)
sw $t1, 396($t2)
j end_draw_frog
frog_backward:
sw $t1, 0($t2)
sw $t1, 12($t2)
sw $t1, 132($t2)
sw $t1, 136($t2)
sw $t1, 256($t2)
sw $t1, 260($t2)
sw $t1, 264($t2)
sw $t1, 268($t2)
sw $t1, 384($t2)
sw $t1, 396($t2)
j end_draw_frog
frog_left:
sw $t1, 0($t2)
sw $t1, 4($t2)
sw $t1, 12($t2)
sw $t1, 132($t2)
sw $t1, 136($t2)
sw $t1, 260($t2)
sw $t1, 264($t2)
sw $t1, 384($t2)
sw $t1, 388($t2)
sw $t1, 396($t2)
j end_draw_frog
frog_right:
sw $t1, 0($t2)
sw $t1, 8($t2)
sw $t1, 12($t2)
sw $t1, 132($t2)
sw $t1, 136($t2)
sw $t1, 260($t2)
sw $t1, 264($t2)
sw $t1, 384($t2)
sw $t1, 392($t2)
sw $t1, 396($t2)
j end_draw_frog
end_draw_frog:
jr $ra

draw_land:
beq $t5, $a1, minus_32
beq $t6, $a0, end_draw_land
draw_line:
beq $t5, $a1, increment
sw $t1, 0($t0)
addi $t0, $t0, 4
addi $t5, $t5, 1
j draw_line
increment:
addi $t6, $t6, 1
j draw_land

minus_32:
subi $t5, $t5, 32
j draw_land

end_draw_land:
jr $ra

######################################################################
# END OF A ROUND
######################################################################

Death:
addi $s2, $s2, 1
beq $s2, 1, remove_life_1
beq $s2, 2, remove_life_2
bge $s2, 3, remove_life_3
j Spawn

remove_life_1:
la $t8, startRow
addi $t8, $t8, 400
lw $t1, green
sw $t1, 0($t8)
j Spawn

remove_life_2:
la $t8, startRow
addi $t8, $t8, 392
lw $t1, green
sw $t1, 0($t8)
j Spawn

remove_life_3:
lw $t8, displayAddress
addi $t8, $t8, 3968
lw $t1, green
sw $t1, 0($t8)
li $t8, 0
li $t1, 0
li $t0, 0
li $t2, 0
li $t9, 0
li $t5, 0
li $t6, 0
li $t7, 0
li $t3, 0
li $t4, 0
j Exit

Goal:

lw $t0, displayAddress
la $t3, frog_y
lw $t4, 0($t3)
la $t3, frog_x
lw $t5, 0($t3)
sll $t4, $t4, 7
sll $t5, $t5, 2
add $t2, $zero, $t4
add $t2, $t2, $t5 
la $t8, safeRow
addi $s7, $s7, -4

j color_goal_square

color_goal_square:
lw $t1, orange
add $t8, $t8, $t2
sw $t1, 0($t8)
sw $t1, 4($t8)
sw $t1, 8($t8)
sw $t1, 12($t8)
addi $t8, $t8, 128
sw $t1, 0($t8)
sw $t1, 4($t8)
sw $t1, 8($t8)
sw $t1, 12($t8)
addi $t8, $t8, 128
sw $t1, 0($t8)
sw $t1, 4($t8)
sw $t1, 8($t8)
sw $t1, 12($t8)
addi $t8, $t8, 128
sw $t1, 0($t8)
sw $t1, 4($t8)
sw $t1, 8($t8)
sw $t1, 12($t8)
la $t8, safeRow
add $t5, $zero, $zero
addi $t6, $zero, 512
lw $t2, displayAddress
jal paint_river
lw $t6, goals
addi $t6, $t6, 1
sw $t6, goals
lw $t6, goals
li $t5, 0
li $t8, 0
li $t4, 0
li $t9, 0
li $t2, 0
li $t1, 0
beq $t6, 4, Exit
j Spawn

Pause:
lw $t8, 0xffff0000
lw $t0, displayAddress
li $t1, 0xffffff
addi $t0, $t0, 2048
sw $t1, 52($t0)
sw $t1, 56($t0)
sw $t1, 64($t0)
sw $t1, 68($t0)
addi $t0, $t0, 128
sw $t1, 52($t0)
sw $t1, 56($t0)
sw $t1, 64($t0)
sw $t1, 68($t0)
addi $t0, $t0, 128
sw $t1, 52($t0)
sw $t1, 56($t0)
sw $t1, 64($t0)
sw $t1, 68($t0)
addi $t0, $t0, 128
sw $t1, 52($t0)
sw $t1, 56($t0)
sw $t1, 64($t0)
sw $t1, 68($t0)
beq $t8, 1, keyboard_input_pause
li $v0, 32
addi $a0, $s7, 0
syscall
j Pause

keyboard_input_pause:
lw $t9, 0xffff0004
beq $t9, 0x70, main
j keyboard_input_pause



Exit:
la $t6, goals
li $t7, 0
sw $t7, 0($t6)
li $t6, 0
la $t8, startRow
addi $t8, $t8, 384
la $t1, green
sw $t1, 0($t8)
jal gameOver
restart:
lw $t9, 0xffff0004
li $t8, 0
li $t2, 0
beq $t9, 0x6e, Start
beq $t9, 0x79, endGame
j restart

endGame:
gameActuallyOver:
lw $t0, displayAddress
li $t1, 0x000000
li $t2, 0
gameActuallyOverLoop:
beq $t2, 4096, endgameActuallyOver
sw $t1, 0($t0)
addi $t0, $t0, 4
addi $t2, $t2, 4
j gameActuallyOverLoop
endgameActuallyOver:
li $v0, 10 # terminate the program gracefully
syscall

gameOver:
lw $t0, displayAddress
li $t1, 0x000000
li $t2, 0
gameOverLoop:
beq $t2, 4096, endgameOver
sw $t1, 0($t0)
addi $t0, $t0, 4
addi $t2, $t2, 4
j gameOverLoop
endgameOver:
lw $t0, displayAddress
li $t1, 0xffffff
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 12($t0)
sw $t1, 20($t0)
sw $t1, 24($t0)
sw $t1, 28($t0)
sw $t1, 36($t0)
sw $t1, 40($t0)
sw $t1, 44($t0)
sw $t1, 48($t0)
sw $t1, 52($t0)
sw $t1, 60($t0)
sw $t1, 64($t0)
sw $t1, 68($t0)
lw $t0, displayAddress
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 20($t0)
sw $t1, 28($t0)
sw $t1, 36($t0)
sw $t1, 44($t0)
sw $t1, 52($t0)
sw $t1, 60($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 8($t0)
sw $t1, 12($t0)
sw $t1, 20($t0)
sw $t1, 24($t0)
sw $t1, 28($t0)
sw $t1, 36($t0)
sw $t1, 44($t0)
sw $t1, 52($t0)
sw $t1, 60($t0)
sw $t1, 64($t0)
sw $t1, 68($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 12($t0)
sw $t1, 20($t0)
sw $t1, 28($t0)
sw $t1, 36($t0)
sw $t1, 44($t0)
sw $t1, 52($t0)
sw $t1, 60($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 12($t0)
sw $t1, 20($t0)
sw $t1, 28($t0)
sw $t1, 36($t0)
sw $t1, 44($t0)
sw $t1, 52($t0)
sw $t1, 60($t0)
sw $t1, 64($t0)
sw $t1, 68($t0)
Over:
lw $t0, displayAddress
addi $t0, $t0, 768
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 16($t0)
sw $t1, 24($t0)
sw $t1, 32($t0)
sw $t1, 36($t0)
sw $t1, 40($t0)
sw $t1, 48($t0)
sw $t1, 52($t0)
sw $t1, 56($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 8($t0)
sw $t1, 16($t0)
sw $t1, 24($t0)
sw $t1, 32($t0)
sw $t1, 48($t0)
sw $t1, 60($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 8($t0)
sw $t1, 16($t0)
sw $t1, 24($t0)
sw $t1, 32($t0)
sw $t1, 36($t0)
sw $t1, 40($t0)
sw $t1, 48($t0)
sw $t1, 52($t0)
sw $t1, 56($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 8($t0)
sw $t1, 16($t0)
sw $t1, 24($t0)
sw $t1, 32($t0)
sw $t1, 48($t0)
sw $t1, 56($t0)
addi $t0, $t0, 128
sw $t1, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 20($t0)
sw $t1, 32($t0)
sw $t1, 36($t0)
sw $t1, 40($t0)
sw $t1, 48($t0)
sw $t1, 60($t0)
addi $t0, $t0, 768
sw $t1, 0($t0)
sw $t1, 8($t0)
sw $t1, 24($t0)
sw $t1, 32($t0)
sw $t1, 44($t0)
addi $t0, $t0, 128
sw $t1, 4($t0)
sw $t1, 20($t0)
sw $t1, 32($t0)
sw $t1, 36($t0)
sw $t1, 44($t0)
addi $t0, $t0, 128
sw $t1, 4($t0)
sw $t1, 16($t0)
sw $t1, 32($t0)
sw $t1, 40($t0)
sw $t1, 44($t0)
addi $t0, $t0, 128
sw $t1, 4($t0)
sw $t1, 12($t0)
sw $t1, 32($t0)
sw $t1, 44($t0)
jr $ra



