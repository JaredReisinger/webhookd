package hook

import (
	"fmt"
	"os"
	"path"
	"path/filepath"

	"github.com/ncarlier/webhookd/pkg/strcase"
)

// Logs get hook log with its name and id
func Logs(id, name, base string) (*os.File, error) {
	logPattern := path.Join(base, fmt.Sprintf("%s_%s_*.txt", strcase.ToSnake(name), id))
	files, err := filepath.Glob(logPattern)
	if err != nil {
		return nil, err
	}
	if len(files) > 0 {
		filename := files[len(files)-1]
		return os.Open(filename)
	}
	return nil, nil
}
