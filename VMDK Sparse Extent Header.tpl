template "VMDK Sparse Extent Header"

// Created by Jens Kirschner

// This template is meant to be applied to a VMware Disk Image 
// (VMDK), that has *not* been interpreted as an image by X-Ways 
// Forensics, because it looks at the so-called Sparse Extent
// Header of the image itself. 


description "To be applied to beginning of VMDK file (while not interpreted as disk)"

requires 0x00 "4B 44 4D 56" // Signature: KDMV (VMDK in Little Endian) 

begin
	char[4]	"Signature: KDMV"
	uint32	"Version"
	uint32	"Flags"
	int64		"Capacity (sectors)"
	int64		"Grain size (sectors)"
	int64		"Descriptor (text) in sector"
	int64		"Descriptor Size (sectors)"
	uint32	"Entries per grain table"
	int64		"Redundant grain directory sector"
	int64		"Grain directory sector"
	int64		"No. of metadata sectors"
	boolean	"Unclean shutdown"

	section "Check values"
	hex 1		"0x0A"
	hex 1		"0x20"
	hex 1		"0x0D"
	hex 1		"0x0A"
	endsection 

	uint16	"CompressionAlgorithm"
end