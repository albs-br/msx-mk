headers_begin:               
			;up to 384 headers, 12 bytes per header = 4608 bytes
			;so 0x200000 + 0x1200 = 0x201200 ... where data should start
		   
			;header sample 0
			db     0x20, 0x12, 0x00                                                                                   ;8 bits & start address at wave memory
			db    (sample_0.size) >> 8
			db    (sample_0.size) and 0xff
			db    ((sample_0.size) xor 0xffFF) >> 8
			db    ((sample_0.size) xor 0xffFF) and 0xff
			db    0x00, 0xf0, 0x00, 0x00, 0x00   ;also works 0x00, 0xf0, 0x00, 0x0f, 0x00
		   


			;header sample 1
			; sample_header	sample_1, (sample_1_end - sample_1)

			db    sample_1 >> 16, (sample_1 >> 8) and 0xff, sample_1 and 0xff                                                                           ;8 bits & start address at wave memory
			db    (sample_1.size) >> 8
			db    (sample_1.size) and 0xff
			db    ((sample_1.size) xor 0xffFF) >> 8
			db    ((sample_1.size) xor 0xffFF) and 0xff
			db    0x00, 0xf0, 0x00, 0x00, 0x00   ;also works 0x00, 0xf0, 0x00, 0x0f, 0x00



			;header sample 2
			; sample_header	sample_2, (sample_2_end - sample_2)

			db    sample_2 >> 16, (sample_2 >> 8) and 0xff, sample_2 and 0xff                                                                           ;8 bits & start address at wave memory
			db    (sample_2.size) >> 8
			db    (sample_2.size) and 0xff
			db    ((sample_2.size) xor 0xffFF) >> 8
			db    ((sample_2.size) xor 0xffFF) and 0xff
			db    0x00, 0xf0, 0x00, 0x00, 0x00   ;also works 0x00, 0xf0, 0x00, 0x0f, 0x00

headers_end:  

		   