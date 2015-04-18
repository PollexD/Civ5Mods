(define (scale-dds-file w h filename-orig filename-destination)
  (let* (
	(image (car (file-dds-load RUN-NONINTERACTIVE filename-orig filename-orig 1 1)))
	 (drawable (car (gimp-image-get-active-layer image)))
	 ;;(w (car (gimp-image-width image)))
	 ;;(h (car (gimp-image-height image)))
	)
	(gimp-image-scale image w h)
	(file-dds-save RUN-NONINTERACTIVE image drawable filename-destination filename-destination
		0 ;; compression format none
		0 ;; no-minimaps
		0 ;; savetype
		0 ;; format
		-1 ;; transparent index disabled
		0 ;; mipmap-filter default
		0 ;; mipmap-wrap default
		0 ;; gamma-correct
		0 ;; srgb
		2.2 ;; gamma value
		0 ;; perceptual-metric
		0 ;; preserve-alpha-coverage
		0.50 ;; alpha-test-threshold
		)
	(gimp-image-delete image)
	)
)

(define (civ5-scale-icons filename)
	(let*
		(
		(filename-base (car (strbreakup filename ".dds")))
		)
	(scale-dds-file 2048 2048 filename (string-append filename-base "256.dds"))
	(scale-dds-file 1024 1024 filename (string-append filename-base "128.dds"))
	(scale-dds-file 640 640 filename (string-append filename-base "80.dds"))
	(scale-dds-file 512 512 filename (string-append filename-base "64.dds"))
	(scale-dds-file 360 360 filename (string-append filename-base "45.dds"))
	(scale-dds-file 256 256 filename (string-append filename-base "32.dds"))
	)
)
