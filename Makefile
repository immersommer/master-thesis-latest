######################################################################
# This Makefile is part of a skeleton (diploma) thesis.  If you have
# useful additions or suggestions, please feel free to contact me:
# Martin Unzner <munzner@os.inf.tu-dresden.de>
# or alternatively
# Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
######################################################################

# your main document
DOC_TEX      = diplom.tex

# your sub documents (chapters)
DOC_TEX_ADD ?= preamble/packages.tex \
               preamble/style.tex \
               preamble/color.tex \
               preamble/newcommands.tex \
               $(wildcard content/*.tex)

# your bibtex databases
DOC_BIB     ?= own.bib

# images
DOC_IMG_JPG  = images/squirrel.jpg # you can specify multiple images here
DOC_IMG_JPG  = images/cri_overviwe.pdf
DOC_IMG_JPG  = images/k8s_with_oci_cri.pdf
DOC_IMG_JPG  = images/k8s_arch.pdf
DOC_IMG_JPG  = images/quark_design.png
DOC_IMG_JPG  = images/quark_io.png
DOC_IMG_JPG  = images/hypercall_qcall_ucall.pdf
DOC_IMG_JPG  = images/vm_process_tee.pdf
DOC_IMG_JPG  = images/TDX_diagram.pdf
DOC_IMG_JPG  = images/IMG_4415.png
DOC_IMG_JPG  = images/IMG_4416.png
DOC_IMG_JPG  = images/IMG_4417.png
DOC_IMG_JPG  = images/IMG_4414.png
DOC_IMG_JPG  = images/IMG_4413.png
DOC_IMG_JPG  = images/fileencption.png
DOC_IMG_JPG  = images/attestation.PNG
DOC_IMG_JPG  = images/resourcerequrie.PNG
DOC_IMG_JPG  = images/Container_Lifecycle_state.PNG



# evaluation images for secureity analyse
DOC_IMG_JPG  = images/generic_policy.PNG
DOC_IMG_JPG  = images/analysis_workload.PNG




# evaluation images for performance
DOC_IMG_JPG  = images/perf_system_call_interceptor_yaml.PNG
DOC_IMG_JPG  = images/ben_results_syscall_interceptor.PNG
DOC_IMG_JPG  = images/perf_attestation_report_yaml.PNG

DOC_IMG_JPG  = images/perf_attestation_report_result.PNG
DOC_IMG_JPG  = images/file_type_secret_access_test_deploy_yaml_baseline.PNG
DOC_IMG_JPG  = images/file_type_secret_access_test_deploy_yaml_cquark.PNG


DOC_IMG_JPG  = images/speed_of_issuing_cmd_in_cquark_kubctl_securectl.PNG

DOC_IMG_JPG  = images/speed_of_issuing_cmd_in_cquark_upstream_quark.PNG
DOC_IMG_JPG  = images/timeshare_issuing_cmd_in_cquark_kubectl_securectl.PNG
DOC_IMG_JPG  = images/timeshare_issuing_cmd_in_cquark_upstream_quark_kubectl.PNG



DOC_IMG_JPG  = images/micro_benchmark_app_life_cycle_bencmark_pattern.png

DOC_IMG_JPG  = images/application_start_microtest_baseline_time_distribution.PNG

DOC_IMG_JPG  = images/application_start_microtest_baseline_time_overhead_each_cmp.PNG


DOC_IMG_JPG  = images/overhead_attestation_agent_as_file_num_increasing.PNG
DOC_IMG_JPG  = images/overhead_secret_injector_as_file_num_increasing.PNG
DOC_IMG_JPG  = images/overhead_software_measurement_manager_as_elf_size_increasing.PNG
DOC_IMG_JPG  = images/startup_time_change_as_elf_size_increasing.PNG
DOC_IMG_JPG  = images/startup_time_change_as_file_type_secret_increasing.PNG




DOC_IMG_JPG  = images/time_disribution_startup_redis_nginx.PNG
DOC_IMG_JPG  = images/reds_nginx_startup_comp.PNG
DOC_IMG_JPG  = images/reds_nginx_exit_comp.PNG
DOC_IMG_JPG  = images/redis_throughput.PNG
DOC_IMG_JPG  = images/nginx_throughput.PNG


DOC_IMG_JPG  = images/Random_Read.PNG
DOC_IMG_JPG  = images/Random_Write.PNG
DOC_IMG_JPG  = images/Sequential_Read.PNG
DOC_IMG_JPG  = images/Sequential_Write.PNG








# latex stuff
LUALATEX    ?= lualatex --synctex=1
BIBER       ?= biber
DETEX       ?= detex
CHECKBIW    ?= checkbiw/src/checkbiw

######################################################################
# You should not need to adapt stuff below this line ...
######################################################################

DOC_PDF      = $(DOC_TEX:.tex=.pdf)
# Use De-TeXed output for the prose analysis, because you
# may have obsolete text commented out, or PGF commands,
# that you do not want to check for flaws
DOC_TXT      = $(DOC_TEX:.tex=.detex)
DOC_BASE     = $(DOC_TEX:.tex=)

DOC_CLEAN    = $(DOC_PDF)									\
               $(DOC_BASE).{aux,log,toc,bcf,bbl,blg,ltf,brf,out} \
			   $(DOC_BASE).{lof,nav,snm,acn,glo,ist,lot,run.xml} \
			   $(DOC_BASE).{synctex,synctex.gz} \
               $(DOC_TXT) $(DOC_TXT_ADD) \
               *~

VERBOSE = @

.PHONY: default pdf clean check-french-spacing checkbiw

default: pdf

$(DOC_PDF): $(DOC_TEX) $(DOC_TEX_ADD) $(DOC_BIB) $(DOC_IMG_JPG)		\
            $(DOC_IMG_PNG) $(DOC_IMG_PNG) $(DOC_IMG_PDF) Makefile
	$(VERBOSE)$(LUALATEX) $(DOC_TEX) || \
	    ((grep 'TeX capacity exceeded' $(DOC_PDF:.pdf=.log) && \
	   echo -e "\n\033[31mIncrease pool_size to 200000 in" \
	           "/etc/texmf/texmf.cnf!\033[m\n" && false) || false)
	$(VERBOSE)[ -f $(DOC_BASE).bcf ] && \
	  $(BIBER) $(DOC_BASE).bcf
	$(VERBOSE)(export size=1 ; touch $(DOC_PDF);\
	  until [ $$size -eq `ls -o $(DOC_PDF) | awk '{print $$4}'` ]; do\
	    export size=`ls -o $(DOC_PDF) | awk '{print $$4}'` ;\
	    $(LUALATEX) $(DOC_TEX) ;\
	  done)

$(DOC_TXT): $(DOC_TEX) $(DOC_TEX_ADD)
	$(DETEX) $(DOC_TEX) > $(DOC_TXT)

pdf: $(DOC_PDF)

clean:
	rm -f $(DOC_CLEAN)

# Points out abbreviations and reminds you of escaping
# the space after the period
check-french-spacing: $(DOC_TEX) $(DOC_TEX_ADD)
	$(VERBOSE)export GREP_COLOR='1;32'; \
	export GREP_OPTIONS='--color=auto'; \
	grep "[A-Z]\{2,\}\." $(DOC_TEX) $(DOC_TEX_ADD) || \
	grep -e 'e\.g\.' -e 'i\.e\.' -e 'd\.h\.' $(DOC_TEX) $(DOC_TEX_ADD) || \
	true

# check for conformance with "bugs in writing", English only
checkbiw: $(DOC_TXT)
	$(VERBOSE)$(CHECKBIW) -v -c $(DOC_TXT)

