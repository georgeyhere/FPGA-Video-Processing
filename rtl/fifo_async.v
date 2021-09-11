// fifo_async.v
//
// This module is an indepedent clocks FIFO.
//
// Follows the Gray code counter - Style #2 from the following paper:
// -> http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
// 
// Another good resource:
// -> http://www.idc-online.com/technical_references/pdfs/electronic_engineering/New_Asynchronous_FIFO_Design.pdf
//
// Formally verified based on:
// -> https://zipcpu.com/blog/2018/07/06/afifo.html
/*
- multi-bit synchronization
    - use an n-bit Gray-code pointer to synchronize read and write pointers
- flags
    - registered for better performance
    - pessimistic
        - flags are removed late
        - two cycle delay due to double FFs
        - note that flags are still set 'accurately'
    - empty flag (read domain)
        - removed with synchronized write pointer
    - full flag  (write domain)
        - removed with synchronized read pointer
*/

module fifo_async 
    #(parameter DATA_WIDTH         = 2,
      parameter PTR_WIDTH          = 4,
      parameter ALMOSTFULL_OFFSET  = 2,
      parameter ALMOSTEMPTY_OFFSET = 2)
     
    (
    input  wire                  i_wclk,
    input  wire                  i_wrstn,
    input  wire                  i_wr,
    input  wire [DATA_WIDTH-1:0] i_wdata,
    output reg                   o_wfull,
    output reg                   o_walmostfull,
    output reg  [PTR_WIDTH-1:0]  o_wfill,

    input  wire                  i_rclk,
    input  wire                  i_rrstn,
    input  wire                  i_rd,
    output wire [DATA_WIDTH-1:0] o_rdata,
    output reg                   o_rempty,
    output reg                   o_ralmostempty,
    output reg  [PTR_WIDTH-1 :0] o_rfill
    );


    reg  [DATA_WIDTH-1:0] mem [0:((1<<PTR_WIDTH)-1)];
 
    reg  [PTR_WIDTH  :0]  rq1_wptr;
    reg  [PTR_WIDTH  :0]  rq2_wptr;

    wire [PTR_WIDTH-1:0] raddr;

    reg  [PTR_WIDTH  :0] rbin; 
    wire [PTR_WIDTH  :0] rbinnext;
    wire [PTR_WIDTH  :0] rbinnext2;

    reg  [PTR_WIDTH  :0] rptr;
    wire [PTR_WIDTH  :0] rgraynext; 

    wire rempty_val;

    reg  [PTR_WIDTH  :0] wq1_rptr;
    reg  [PTR_WIDTH  :0] wq2_rptr;

    wire [PTR_WIDTH-1:0] waddr;

    reg  [PTR_WIDTH  :0] wbin;
    wire [PTR_WIDTH  :0] wbinnext;

    reg  [PTR_WIDTH  :0] wptr;
    wire [PTR_WIDTH  :0] wgraynext;

    wire wfull_val;

//
// FIFO MEMORY
// synthesized with ram primitives
    assign o_rdata = mem[raddr];
    always@(posedge i_wclk) begin
        if((i_wr) && (!o_wfull)) mem[waddr] <= i_wdata;
    end

    /*
    always@(posedge i_rclk) begin
        o_rdata <= mem[raddr];
    end
    */

//
// synchronize write pointer to read clock domain
//
    initial {rq1_wptr, rq2_wptr} = 0;
    always@(posedge i_rclk or negedge i_rrstn) begin
        if(!i_rrstn) {rq2_wptr, rq1_wptr} <= 0;
        else         {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
    end

//
// read pointer and empty generation logic
//
    // MEMORY READ ADDRESS POINTER (binary)
    assign raddr = rbin[PTR_WIDTH-1:0];

    // BINARY COUNTER FOR MEMORY ADDRESSING
    initial rbin = 0;
    always@(posedge i_rclk or negedge i_rrstn) begin
        if(!i_rrstn) rbin <= 0;
        else         rbin <= rbinnext;
    end
    assign rbinnext  = rbin + { {(PTR_WIDTH){1'b0}}, ((i_rd)&&(!o_rempty)) };


     // GRAY-CODE READ POINTER
    initial rptr = 0;
    always@(posedge i_rclk or negedge i_rrstn) begin
        if(!i_rrstn) rptr <= 0;
        else         rptr <= rgraynext;
    end
    assign rgraynext = (rbinnext >> 1) ^ rbinnext;

    // EMPTY FLAG LOGIC
    initial o_rempty = 1;
    always@(posedge i_rclk or negedge i_rrstn) begin 
        if(!i_rrstn) o_rempty <= 1;
        else         o_rempty <= rempty_val; 
    end
    assign rempty_val = (rgraynext == rq2_wptr);

    // READ FILL LEVEL
    wire [PTR_WIDTH:0] rdiff;
    wire [PTR_WIDTH:0] rq2_wptr_bin;
    assign rq2_wptr_bin[PTR_WIDTH] = rq2_wptr[PTR_WIDTH];
    for(genvar i=PTR_WIDTH-1; i>=0; i=i-1) begin
        xor(rq2_wptr_bin[i], rq2_wptr[i], rq2_wptr_bin[i+1]);
    end

    assign rdiff = (rbinnext <= rq2_wptr_bin) ? (rq2_wptr_bin - rbinnext) :
                                    ((1<<(PTR_WIDTH+1)) - rbinnext + rq2_wptr_bin); 

    always@(posedge i_rclk or negedge i_rrstn) begin
        if(!i_rrstn) o_rfill <= 0;
        else         o_rfill <= rdiff;
    end

    // ALMOST EMPTY FLAG
    wire almostempty_val;
    assign almostempty_val = (rdiff <= ALMOSTEMPTY_OFFSET);
    always@(posedge i_rclk or negedge i_rrstn) begin
        if(!i_rrstn) o_ralmostempty <= 1;
        else         o_ralmostempty <= almostempty_val;
    end

// ****
//
//

//
// synchronize read pointer to write clock domain
//
    initial {wq1_rptr, wq2_rptr} = 0;
    always@(posedge i_wclk or negedge i_wrstn) begin
        if(!i_wrstn) {wq2_rptr, wq1_rptr} <= 0;
        else         {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
    end

//
// write pointer and full generation logic
//
    // MEMORY WRITE ADDRESS POINTER (binary)
    assign waddr = wbin[PTR_WIDTH-1:0];

    // BINARY COUNTER FOR MEMORY ADDRESSING
    initial wbin = 0;
    always@(posedge i_wclk or negedge i_wrstn) begin
        if(!i_wrstn) wbin <= 0;
        else         wbin <= wbinnext;
    end
    assign wbinnext = wbin + { {(PTR_WIDTH){1'b0}}, ((i_wr) && (!o_wfull)) };

    // GRAY-CODE WRITE POINTER
    initial wptr = 0;
    always@(posedge i_wclk or negedge i_wrstn) begin
        if(!i_wrstn) wptr <= 0;
        else         wptr <= wgraynext;
    end
    assign wgraynext = (wbinnext >> 1) ^ wbinnext; // 100

    // FULL FLAG LOGIC
    initial o_wfull = 0;
    always@(posedge i_wclk or negedge i_wrstn) begin
        if(!i_wrstn) o_wfull <= 0;
        else         o_wfull <= wfull_val;
    end
    assign wfull_val = (wgraynext == {~wq2_rptr[PTR_WIDTH:PTR_WIDTH-1], 
                                       wq2_rptr[PTR_WIDTH-2:0]});

    // WRITE FILL LEVEL
    wire [PTR_WIDTH:0] wdiff;
    wire [PTR_WIDTH:0] wq2_rptr_bin;
    assign wq2_rptr_bin[PTR_WIDTH] = wq2_rptr[PTR_WIDTH];
    for(genvar i=PTR_WIDTH-1; i>=0; i=i-1) begin
        xor(wq2_rptr_bin[i], wq2_rptr[i], wq2_rptr_bin[i+1]);
    end

    assign wdiff = (wq2_rptr_bin <= wbinnext) ? (wbinnext - wq2_rptr_bin) :
                                    ((1<<(PTR_WIDTH+1)) - wq2_rptr_bin + wbinnext); 

    always@(posedge i_wclk or negedge i_wrstn) begin
        if(!i_wrstn) o_wfill <= 0;
        else         o_wfill <= wdiff;
    end

    // ALMOST FULL FLAG
    wire almostfull_val;
    assign almostfull_val = (o_wfill >= ( ((1<<PTR_WIDTH)-ALMOSTFULL_OFFSET)) ) ||
                            (wgraynext == {~wq2_rptr[PTR_WIDTH:PTR_WIDTH-1], wq2_rptr[PTR_WIDTH-2:0]});
                                                       
    always@(posedge i_wclk or negedge i_wrstn) begin
        if(!i_wrstn) o_walmostfull <= 1;
        else         o_walmostfull <= almostfull_val;
    end

//
//
//
// ***********************************************************
// FORMAL VERIFICATION
// ***********************************************************
//
//
//  wsl sby -f fifo_async.sby

`ifdef FORMAL 
// note that f_ and F_ denote formal-only variables


// **** PAST_VALID SETUP ****
// will be used so assertions aren't checked at time step 0
    reg f_past_valid_rd;
    reg f_past_valid_wr;
    reg f_past_valid_gbl;

    initial f_past_valid_rd = 0;
    always@(posedge i_rclk) f_past_valid_rd <= 1;

    initial f_past_valid_wr = 0;
    always@(posedge i_wclk) f_past_valid_wr <= 1;

    initial f_past_valid_gbl = 0;
    always@($global_clock) f_past_valid_gbl <= 1;

    always@* 
        if(!f_past_valid_gbl) 
            assert((!f_past_valid_wr) && (!f_past_valid_rd));


// **** READ/WRITE CLOCK SETUP ****
// Create arbitrary clock steps for each clock
// Solver will choose the values for each 
    localparam F_CLKBITS = 5;
    wire [F_CLKBITS-1:0] f_wclk_step, f_rclk_step;
    assign f_wclk_step = $anyconst;
    assign f_rclk_step = $anyconst;

    // assume that both clock steps are always greater than 0:
    always@* begin
        assume(f_wclk_step != 0);
        assume(f_rclk_step != 0);
    end

    // count the clock steps:
    reg [F_CLKBITS-1:0] f_wclk_count, f_rclk_count;
    always@($global_clock) begin // $global_clock refers to solver time step
        f_wclk_count <= f_wclk_count + f_wclk_step;
        f_rclk_count <= f_rclk_count + f_rclk_step;
    end

    // assume the clocks themselves = MSB of respective counters
    always@* begin
        assume(i_wclk == f_wclk_count[F_CLKBITS-1]);
        assume(i_rclk == f_rclk_count[F_CLKBITS-1]);
    end


// **** ASYNC RESET CHECK ****
// Asynchronous resets with synchronous release
// Both resets asserted at same time but released w/ respective clocks
    
    // initialize both resets to same value
    initial assume(i_wrstn == i_rrstn);
    
    // assert resets at the same time
    always@($global_clock) 
        assume($fell(i_wrstn) == $fell(i_rrstn));

    // resets are only released on their respective clocks
    always@($global_clock) 
        if(!$rose(i_wclk))
            assume(!$rose(i_wrstn));

    always@($global_clock)
        if(!$rose(i_rclk))
            assume(!$rose(i_rrstn));
   
    always@($global_clock) 
        if(!i_wrstn) 
            assert(rbin == 0); 
            

// **** ASSUME INPUTS ARE SYNCHRONOUS ****
// synchronous input -> inputs are stable on non-edge

    always@($global_clock) begin
        if(f_past_valid_gbl) begin
            if(!$rose(i_wclk)) begin
                assume($stable(i_wr));
                assume($stable(i_wdata));
    
                // if reset asserted, full flag will drop asynchronously
                assert($stable(o_wfull)||(!i_wrstn)); 
            end
            if(!$rose(i_rclk)) begin
                assume($stable(i_rd));
    
                // if reset asserted, output read data and empty flag will drop as well
                assert(($stable(o_rdata))||(o_rempty)); 
                assert(($stable(o_rempty))||(!i_rrstn));
            end
        end
    end


// **** CHECK VALUES ON RESET ****
// check that 
    always@($global_clock) begin
        if((!f_past_valid_wr)||(!i_wrstn)) begin
            assume(i_wr == 0);
            //
            assert(wptr == 0);
            assert(wbin == 0);
            assert(!o_wfull);
            //
            assert(rbin == 0);
            assert(o_rempty);
            //
            assert(wq1_rptr == 0);
            assert(wq2_rptr == 0);
            assert(rq1_wptr == 0);
            assert(rq2_wptr == 0);
        end
    end

    always@($global_clock) begin
        if((!f_past_valid_rd)||(!i_rrstn)) begin
            assume(i_rd == 0);
            //
            assert(rptr == 0);
            assert(rbin == 0);
            assert(o_rempty);
            //
            assert(wq1_rptr == 0);
            assert(wq2_rptr == 0);
            assert(rq1_wptr == 0);
            assert(rq2_wptr == 0);
        end
    end



// **** VERIFY FIFO POINTERS ****
// Check asynchrnous FIFO data writes
// Check asynchrnous FIFO data reads
// -> note that this is the 'true' level of fill in the FIFO
// --> the actual FIFO empty/full logic will never know this value
    
    wire [PTR_WIDTH:0] f_fill;

    assign f_fill = (wbin - rbin);

    // check FIFO is initially empty
    initial assert(f_fill == 0);

    // check that FIFO is never overfilled
    always@($global_clock)
        assert(f_fill <= {1'b1, {PTR_WIDTH{1'b0}} }); 

    // check that full flag is asserted when FIFO is full
    always@($global_clock)
        if(f_fill == {1'b1, {(PTR_WIDTH){1'b0}} })
            assert(o_wfull);

    // check next state behavior for when FIFO is about to be full
    always@($global_clock)
        if(f_fill == {1'b1, {PTR_WIDTH{1'b0}} })    
            assert((wfull_val) || (!i_wr) || (o_wfull));

    // check that empty flag is asserted when FIFO is empty
    always@($global_clock)
        if(f_fill == 0)
            assert(o_rempty);

    // check next state behavior for when FIFO is about to be emptied
    always@($global_clock)
        if(f_fill == 1)
            assert((rempty_val) || (!i_rd) || (o_rempty));

    // check binary to gray code translations
    always@*
        assert(wptr == ((wbin>>1)^wbin));
    always@*
        assert(rptr == ((rbin>>1)^rbin));

    // compare the read and write pointers when FIFO is full
    always@*
        assert( (rptr == { ~wptr[PTR_WIDTH:PTR_WIDTH-1], wptr[PTR_WIDTH-2:0] }) ==
                (f_fill == {1'b1, {PTR_WIDTH{1'b0}} }) );

    // check that read and write pointers are equal when FIFO is empty
    always@*
        assert((rptr == wptr) == (f_fill == 0));



// **** CHECK CDC REGS ****
// 
    reg  [PTR_WIDTH:0] f_w2r_rbin, f_w1r_rbin;
    reg  [PTR_WIDTH:0] f_r2w_wbin, f_r1w_wbin;

    wire [PTR_WIDTH:0] f_w2r_fill, f_r2w_fill;

    // create formal versions of cdc regs
    //
    initial {f_w2r_rbin, f_w1r_rbin} = 0;
    always@(posedge i_wclk or negedge i_wrstn) 
        if(!i_wrstn)
            {f_w2r_rbin, f_w1r_rbin} <= 0;
        else
            {f_w2r_rbin, f_w1r_rbin} <= {f_w1r_rbin, rbin};

    initial {f_r2w_wbin, f_r1w_wbin} = 0;
    always@(posedge i_rclk or negedge i_rrstn)
        if(!i_rrstn)
            {f_r2w_wbin, f_r1w_wbin} <= 0;
        else
            {f_r2w_wbin, f_r1w_wbin} <= {f_r1w_wbin, wbin};

    // check that cdc regs are valid with respect to actual pointers
    //  -> compare formal version to real 
    always@*
        assert(rq1_wptr == ((f_r1w_wbin >> 1) ^ f_r1w_wbin));
    always@*
        assert(rq2_wptr == ((f_r2w_wbin >> 1) ^ f_r2w_wbin));
    always@*
        assert(wq1_rptr == ((f_w1r_rbin >> 1) ^ f_w1r_rbin));
    always@*
        assert(wq2_rptr == ((f_w2r_rbin >> 1) ^ f_w2r_rbin));

    // get fill from cdc regs
    assign f_w2r_fill = wbin - f_w2r_rbin;
    assign f_r2w_fill = f_r2w_wbin - rbin;

    // check that cdc regs' fill level within legal bounds
    always@*
        assert(f_w2r_fill <= {1'b1, {(PTR_WIDTH){1'b0}} });
    always@* 
        assert(f_r2w_fill <= {1'b1, {(PTR_WIDTH){1'b0}} });

// **** CHECK FULL/EMPTY FLAGS ****
//
    always@* 
        if(wptr == { ~wq2_rptr[PTR_WIDTH:PTR_WIDTH-1], wq2_rptr[PTR_WIDTH-2:0] })
            assert(o_wfull);

    always@*
        if(rptr == rq2_wptr)
            assert(o_rempty);


// ******** FIFO FORMAL CONTRACT ********
//
// The contract for this FIFO is straightforward:
//
//    1) Write two consecutive items into the FIFO, starting from
//       an arbitrary address.
//       These items are stored in a formal-only register.
//
//    2) Read the first item from the FIFO and compare against
//       the first stored value.
//
//    3) Read the second item from the FIFO and compare against
//       the second stored value.
//
    

    // get arbitrary address
    (* anyconst *) wire [PTR_WIDTH-1:0] f_const_addr;
    wire [PTR_WIDTH:0] f_const_next_addr;
    assign f_const_next_addr = f_const_addr + 1;

    // get arbitrary values
    (* anyconst *) reg [DATA_WIDTH-1:0] f_const_first, f_const_next;

    // create valid signals indicating if test addresses are in FIFO range
    // FIFO range -> i.e. within bounds of wptr - rptr
    reg f_addr_valid, f_next_valid;
    always@* begin
        f_addr_valid = 0;
        if((wbin > rbin) && (wbin > f_const_addr) && (rbin <= f_const_addr))
            f_addr_valid = 1;
        else if ((wbin < rbin) && (f_const_addr < wbin))
            f_addr_valid = 1;
        else if((wbin < rbin) && (f_const_addr >= rbin))
            f_addr_valid = 1;
    end

    always@* begin
        f_next_valid = 0;
        if((rbin < wbin) && (f_const_next_addr < wbin) && (rbin <= f_const_next_addr))
            f_next_valid = 1;
        else if ((wbin < rbin) && (f_const_next_addr < wbin))
            f_next_valid = 1;
        else if ((wbin < rbin) && (f_const_next_addr >= rbin))
            f_next_valid = 1;
    end

    // check that correct data is loaded into correct addresses
    reg f_first_in_fifo, f_second_in_fifo, f_both_in_fifo;

    always@* begin
        f_first_in_fifo = 0;
        if( (f_addr_valid) && (mem[f_const_addr] == f_const_first) )
            f_first_in_fifo = 1;
    end

    always@* begin
        f_second_in_fifo = 0;
        if( (f_next_valid) && (mem[f_const_next_addr] == f_const_next) )
            f_second_in_fifo = 1;
    end

    always@* 
        f_both_in_fifo = (f_first_in_fifo && f_second_in_fifo);

    // define states:
    reg f_wait_for_first_read, f_wait_for_second_read;
    reg f_read_first, f_read_second;

    always@* 
        f_wait_for_first_read = (f_both_in_fifo && 
                                 ((!i_rd)||(f_const_addr != rbin) || (o_rempty)));

    always@* 
        f_read_first = ((f_both_in_fifo) && (i_rd) && (f_const_addr == rbin) &&
                        (!o_rempty) && (o_rdata == f_const_first));

    always@* 
        f_wait_for_second_read = ((f_second_in_fifo) && 
                                  ((!i_rd)||(o_rempty)) &&
                                  (f_const_next_addr == rbin));

    always@* 
        f_read_second = ((f_second_in_fifo) && (!o_rempty) &&
                         (i_rd) && (rbin == f_const_next_addr) &&
                         (o_rdata == f_const_next));

    // state checker:
    // Note the checker is disabled when the write reset is asserted
    always@($global_clock) begin
        if(f_past_valid_gbl && i_wrstn) begin

            // both items in the FIFO; first item not read yet
            if( (!$past(f_read_first)) && ($past(f_both_in_fifo)) )
 
                assert(
                        // waiting for first read still 
                       (f_wait_for_first_read) || 

                       // reading first item on clock edge
                       (($rose(i_rclk)) && (f_read_first)) 
                       );

            // first item has been read
            if($past(f_read_first)) 
                assert( 
                        // still in f_read_first state
                        ((!$rose(i_rclk)) && (f_read_first)) || 

                        // or on next clock edge: waiting for second read OR reading second
                        ($rose(i_rclk) && ((f_read_second) || (f_wait_for_second_read)))
                      );


            if($past(f_wait_for_second_read))
                assert ( (f_wait_for_second_read) ||
                         (($rose(i_rclk)) && (f_read_second)));

                          
        end
    end

//
// **** COVER STATEMENTS ****
//
    always@(posedge i_wclk) 
        cover(i_wrstn);

    always@(posedge i_rclk) 
        cover(i_rrstn);

    always@($global_clock)
        if(f_past_valid_gbl)
            cover((o_rempty)&&(!$past(o_rempty)));

    always@* 
        if(f_past_valid_gbl)
            cover(o_wfull);

    always@(posedge i_wclk) 
        if(f_past_valid_wr)
            cover($past(o_wfull)&&(!o_wfull));

    always@(posedge i_wclk)
        cover(i_wr);

    always@(posedge i_rclk)
        cover((o_rempty) && (i_rd));

`endif

endmodule