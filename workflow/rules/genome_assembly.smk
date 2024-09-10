import re
import subprocess
import os

# Import Prefix Variable for Analysis Name
prefix = config["prefix"]

# Import Path to Log Directory
logs = config["base_log_outdir"]

rule run_shovill:
    input:
        r1_filt = config['outdir']+"/{prefix}/fastp/{sample}.R1.fastq.gz",
        r2_filt = config['outdir']+"/{prefix}/fastp/{sample}.R2.fastq.gz"
    output:
        assembly = config['outdir']+"/{prefix}/shovill/assemblies/{sample}.fasta",
        shovill_outdir = directory(config['outdir']+"/{prefix}/shovill/{sample}_out")
    log:
        out = config['base_log_outdir']+"/{prefix}/shovill/run/{sample}.out.log",
        err = config['base_log_outdir']+"/{prefix}/shovill/run/{sample}.err.log"
    threads:
        6
    conda:
        "../envs/shovill.yaml"
    shell:
        """
        shovill --outdir {output.shovill_outdir} --R1 {input.r1_filt} --R2 {input.r2_filt} --cpus {threads} --minlen 200 --mincov 30 > {log.out} 2> {log.err}       
        cp {output.shovill_outdir}/contigs.fa {output.assembly}
        """